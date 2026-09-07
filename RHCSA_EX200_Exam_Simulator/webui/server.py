#!/usr/bin/env python3
"""
RHCSA Exam Simulator - Web API Server
Provides REST API for the web interface
"""

import os
import sys
import json
import subprocess
import re
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import threading
import signal

# Configuration
WEBUI_PORT = 8080
TERMINAL_PORT = 7682
TMUX_SESSION = 'rhcsa-terminal'
MAIN_WINDOW_NAME = 'lab_main'  # stable tmux window name for the default/first terminal tab
QUESTIONS_DIR = "/usr/local/share/rhcsa/questions"
PROGRESS_FILE = "/usr/local/share/rhcsa/.progress"
WEBUI_DIR = "/usr/local/share/rhcsa/webui"

class RHCSAAPIHandler(SimpleHTTPRequestHandler):
    """Custom HTTP handler for RHCSA API"""
    
    def __init__(self, *args, **kwargs):
        # Set the directory for serving static files
        super().__init__(*args, directory=WEBUI_DIR, **kwargs)
    
    def log_message(self, format, *args):
        """Suppress default logging"""
        pass
    
    def do_GET(self):
        """Handle GET requests"""
        parsed = urlparse(self.path)
        
        if parsed.path.startswith('/api/'):
            self.handle_api_get(parsed.path)
        else:
            # Serve static files
            super().do_GET()
    
    def do_POST(self):
        """Handle POST requests"""
        parsed = urlparse(self.path)
        
        if parsed.path.startswith('/api/'):
            self.handle_api_post(parsed.path)
        else:
            self.send_error(404)
    
    def handle_api_get(self, path):
        """Handle API GET requests"""
        if path.startswith('/api/questions/'):
            # Get questions for an objective
            obj_id = path.split('/')[-1]
            self.send_json(get_questions(obj_id))
        
        elif path == '/api/progress':
            # Get completion progress
            self.send_json(get_progress())
        
        elif path == '/api/objectives':
            # Get all objectives
            self.send_json(get_objectives())
        
        elif path == '/api/version/check':
            # Check for updates
            self.send_json(check_version())
        
        else:
            self.send_error(404)
    
    def handle_api_post(self, path):
        """Handle API POST requests"""
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length).decode('utf-8')
        
        try:
            data = json.loads(body) if body else {}
        except json.JSONDecodeError:
            data = {}
        
        if path == '/api/lab/start':
            result = start_lab(data)
            self.send_json(result)
        
        elif path == '/api/lab/check':
            result = check_lab(data)
            self.send_json(result)
        
        elif path == '/api/lab/hint':
            result = get_hint(data)
            self.send_json(result)
        
        elif path == '/api/lab/exit':
            result = exit_lab(data)
            self.send_json(result)
        
        elif path == '/api/terminal/send':
            result = send_to_terminal(data)
            self.send_json(result)
        
        elif path == '/api/terminal/select':
            result = select_terminal(data)
            self.send_json(result)
        
        elif path == '/api/update/run':
            result = run_update()
            self.send_json(result)
        
        else:
            self.send_error(404)
    
    def send_json(self, data):
        """Send JSON response"""
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))


def get_objectives():
    """Get list of objectives"""
    return [
        {"id": 1, "title": "Understand and use essential tools"},
        {"id": 2, "title": "Manage software"},
        {"id": 3, "title": "Create simple shell scripts"},
        {"id": 4, "title": "Operate running systems"},
        {"id": 5, "title": "Configure local storage"},
        {"id": 6, "title": "Create and configure file systems"},
        {"id": 7, "title": "Deploy, configure, and maintain systems"},
        {"id": 8, "title": "Manage basic networking"},
        {"id": 9, "title": "Manage users and groups"},
        {"id": 10, "title": "Manage security"}
    ]


def get_questions(obj_id):
    """Get questions for an objective"""
    questions = []
    if not re.fullmatch(r'[1-9][0-9]*', str(obj_id)):
        return questions
    obj_dir = os.path.join(QUESTIONS_DIR, str(obj_id))
    
    if not os.path.isdir(obj_dir):
        return questions
    
    # Get all .sh files and sort them
    files = sorted([f for f in os.listdir(obj_dir) if f.endswith('.sh')])
    
    for filename in files:
        filepath = os.path.join(obj_dir, filename)
        question_data = parse_question_file(filepath)
        if question_data:
            question_data['file'] = filename
            questions.append(question_data)
    
    return questions


def parse_question_file(filepath):
    """Parse a question file and extract metadata"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extract QUESTION
        question_match = re.search(r'QUESTION="([^"]*)"', content)
        question = question_match.group(1) if question_match else "Unknown Question"
        
        # Extract IS_LAB
        is_lab = 'IS_LAB=true' in content
        
        # Extract LAB_TASK_COUNT
        task_count_match = re.search(r'LAB_TASK_COUNT=(\d+)', content)
        task_count = int(task_count_match.group(1)) if task_count_match else 0
        
        return {
            'question': question,
            'is_lab': is_lab,
            'task_count': task_count
        }
    except Exception as e:
        print(f"Error parsing {filepath}: {e}")
        return None


def get_progress():
    """Get completed labs"""
    completed = []
    
    if os.path.exists(PROGRESS_FILE):
        try:
            with open(PROGRESS_FILE, 'r') as f:
                completed = [line.strip() for line in f if line.strip()]
        except Exception:
            pass
    
    return {'completed': completed}


def reset_terminal():
    """Reset the terminal: drop any extra tabs from a previous lab, keep just the main one"""
    try:
        # List existing windows (in index order) and keep only the first one
        result = subprocess.run(
            ['tmux', 'list-windows', '-t', TMUX_SESSION, '-F', '#{window_index}'],
            capture_output=True, text=True
        )
        indices = [line.strip() for line in result.stdout.splitlines() if line.strip()]

        if indices:
            keeper = indices[0]
            for idx in indices[1:]:
                subprocess.run(['tmux', 'kill-window', '-t', f'{TMUX_SESSION}:{idx}'], capture_output=True)
            subprocess.run(
                ['tmux', 'rename-window', '-t', f'{TMUX_SESSION}:{keeper}', MAIN_WINDOW_NAME],
                capture_output=True
            )

        # Send Ctrl+C to cancel any running command, then clear and cd to /tmp
        subprocess.run(
            ['tmux', 'send-keys', '-t', f'{TMUX_SESSION}:{MAIN_WINDOW_NAME}', 'C-c'],
            capture_output=True
        )
        subprocess.run(
            ['tmux', 'send-keys', '-t', f'{TMUX_SESSION}:{MAIN_WINDOW_NAME}', 'clear; cd /tmp', 'Enter'],
            capture_output=True
        )
    except Exception as e:
        print(f"Error resetting terminal: {e}")


def create_extra_terminal(window_name, command=None):
    """Create an additional tmux window (terminal tab) on the same machine.
    If a command is given (e.g. 'docker exec -it <name> bash') it runs in that
    window instead of a plain shell."""
    try:
        cmd = ['tmux', 'new-window', '-d', '-t', TMUX_SESSION, '-n', window_name, '-c', '/tmp']
        if command:
            cmd.append(command)
        subprocess.run(cmd, capture_output=True)
    except Exception as e:
        print(f"Error creating terminal window {window_name}: {e}")


def select_terminal(data):
    """Switch the shared terminal view to a different tab (tmux window)"""
    window = data.get('window', '')

    if not window or not re.fullmatch(r'[A-Za-z0-9_-]+', window):
        return {'error': 'Invalid window', 'success': False}

    try:
        result = subprocess.run(
            ['tmux', 'select-window', '-t', f'{TMUX_SESSION}:{window}'],
            capture_output=True
        )
        return {'success': result.returncode == 0}
    except Exception as e:
        return {'error': str(e), 'success': False}


def resolve_lab_filepath(obj_id, filename):
    """Validate obj_id/filename and return a safe path under QUESTIONS_DIR, or None"""
    if not obj_id or not filename:
        return None
    if not re.fullmatch(r'[1-9][0-9]*', str(obj_id)):
        return None
    if not re.fullmatch(r'[A-Za-z0-9_.-]+\.sh', filename):
        return None

    base = os.path.realpath(QUESTIONS_DIR)
    filepath = os.path.realpath(os.path.join(QUESTIONS_DIR, str(obj_id), filename))

    if os.path.commonpath([base, filepath]) != base:
        return None

    return filepath


def start_lab(data):
    """Start a lab exercise"""
    obj_id = data.get('objective')
    idx = data.get('index')
    filename = data.get('file')
    
    filepath = resolve_lab_filepath(obj_id, filename)
    
    if not filepath or not os.path.exists(filepath):
        return {'error': 'Lab file not found'}
    
    # Parse the lab file
    lab_data = parse_lab_file(filepath)
    
    if not lab_data:
        return {'error': 'Failed to parse lab file'}
    
    # Reset terminal before starting new lab
    reset_terminal()
    
    # Run prepare_lab (main/default terminal tab)
    run_lab_function(filepath, 'prepare_lab')
    
    # Create and prepare any additional terminal tabs (prepare_lab_2, prepare_lab_3, ...)
    for terminal in lab_data.get('terminals', [])[1:]:
        create_extra_terminal(terminal['window'], terminal.get('command'))
        run_lab_function(filepath, f"prepare_lab_{terminal['index']}")
    
    # Make sure the student lands on the main tab, regardless of how many tabs exist
    subprocess.run(['tmux', 'select-window', '-t', f'{TMUX_SESSION}:{MAIN_WINDOW_NAME}'], capture_output=True)
    
    return lab_data


def parse_extra_terminals(content):
    """Find prepare_lab_N (N>=2) functions in a lab file and their optional tab names.
    Web UI only - the CLI simulator ignores these and only ever calls prepare_lab()."""
    terminals = []
    indices = sorted(set(int(m) for m in re.findall(r'\bprepare_lab_(\d+)\s*\(\)', content)))

    for n in indices:
        name_match = re.search(rf'PREPARE_LAB_{n}_NAME="([^"]*)"', content)
        name = name_match.group(1) if name_match else f'Terminal {n}'
        command_match = re.search(rf'PREPARE_LAB_{n}_COMMAND="([^"]*)"', content)
        command = command_match.group(1) if command_match else None
        terminals.append({'index': n, 'name': name, 'window': f'lab_{n}', 'command': command})

    return terminals


def parse_lab_file(filepath):
    """Parse a lab file and extract all metadata"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extract QUESTION
        question_match = re.search(r'QUESTION="([^"]*)"', content)
        question = question_match.group(1) if question_match else "Unknown Lab"
        
        # Extract LAB_TASK_COUNT
        task_count_match = re.search(r'LAB_TASK_COUNT=(\d+)', content)
        task_count = int(task_count_match.group(1)) if task_count_match else 0
        
        # Extract optional extra terminal tabs (prepare_lab_2, prepare_lab_3, ...)
        extra_terminals = parse_extra_terminals(content)
        main_name_match = re.search(r'PREPARE_LAB_1_NAME="([^"]*)"', content)
        main_name = main_name_match.group(1) if main_name_match else 'Terminal'
        terminals = [{'index': 1, 'name': main_name, 'window': MAIN_WINDOW_NAME}] + extra_terminals if extra_terminals else []
        
        # Extract tasks
        tasks = []
        for i in range(1, task_count + 1):
            task_match = re.search(rf'TASK_{i}_QUESTION="([^"]*)"', content)
            if task_match:
                tasks.append(task_match.group(1))
        
        # Extract hints for each task
        task_hints = {}
        for i in range(1, task_count + 1):
            hint_match = re.search(rf'TASK_{i}_HINT="([^"]*)"', content)
            if hint_match:
                task_hints[i] = hint_match.group(1)
        
        # Extract commands as structured array with hints
        commands = []
        for i in range(1, task_count + 1):
            task_hint = task_hints.get(i, '')
            for j in range(1, 10):  # Support up to 9 commands per task
                cmd_match = re.search(rf'TASK_{i}_COMMAND_{j}="([^"]*)"', content)
                if cmd_match:
                    commands.append({
                        'task': i,
                        'label': f'Task {i}' + (f' - Command {j}' if j > 1 else ''),
                        'hint': task_hint if j == 1 else '',  # Show hint only for first command of each task
                        'command': cmd_match.group(1)
                    })
        
        return {
            'question': question,
            'tasks': tasks,
            'task_count': task_count,
            'commands': commands,
            'terminals': terminals
        }
    except Exception as e:
        print(f"Error parsing lab file {filepath}: {e}")
        return None


def run_lab_function(filepath, function_name):
    """Run a function from a lab file"""
    try:
        # filepath is passed as $1 (not interpolated) so it can't break out of the script
        script = f'''
#!/bin/bash
# Colors
RESET=$'\\e[0m'
DIM="\\033[2m"
GREEN="\\033[32m"

source "$1"
{function_name}
'''
        subprocess.run(['bash', '-c', script, 'bash', filepath], capture_output=True, timeout=30)
    except Exception as e:
        print(f"Error running {function_name}: {e}")


def check_lab(data):
    """Check lab task completion"""
    obj_id = data.get('objective')
    filename = data.get('file')
    
    filepath = resolve_lab_filepath(obj_id, filename)
    
    if not filepath or not os.path.exists(filepath):
        return {'error': 'Lab file not found'}
    
    # Get task count
    lab_data = parse_lab_file(filepath)
    task_count = lab_data.get('task_count', 0) if lab_data else 0
    
    # Run check_tasks and capture results
    status = run_check_tasks(filepath, task_count)
    
    all_complete = all(status) if status else False
    
    # If all complete, mark as completed
    if all_complete:
        mark_lab_completed(filename)
    
    return {
        'status': status,
        'allComplete': all_complete
    }


def run_check_tasks(filepath, task_count):
    """Run check_tasks and return status array"""
    try:
        # filepath is passed as $1 (not interpolated) so it can't break out of the script
        script = f'''
#!/bin/bash
declare -a TASK_STATUS
source "$1"
check_tasks
for ((i=0; i<{task_count}; i++)); do
    echo "${{TASK_STATUS[$i]}}"
done
'''
        result = subprocess.run(['bash', '-c', script, 'bash', filepath], capture_output=True, text=True, timeout=30)
        
        # Parse output
        lines = result.stdout.strip().split('\n')
        status = []
        for line in lines:
            status.append(line.strip().lower() == 'true')
        
        # Pad with False if needed
        while len(status) < task_count:
            status.append(False)
        
        return status[:task_count]
    except Exception as e:
        print(f"Error running check_tasks: {e}")
        return [False] * task_count


def mark_lab_completed(filename):
    """Mark a lab as completed"""
    try:
        # Read existing completions
        completed = set()
        if os.path.exists(PROGRESS_FILE):
            with open(PROGRESS_FILE, 'r') as f:
                completed = set(line.strip() for line in f if line.strip())
        
        # Add this lab
        completed.add(filename)
        
        # Write back
        with open(PROGRESS_FILE, 'w') as f:
            for lab in sorted(completed):
                f.write(lab + '\n')
    except Exception as e:
        print(f"Error marking lab completed: {e}")


def get_hint(data):
    """Get hint for a lab"""
    obj_id = data.get('objective')
    filename = data.get('file')
    
    filepath = resolve_lab_filepath(obj_id, filename)
    
    if not filepath or not os.path.exists(filepath):
        return {'error': 'Lab file not found', 'commands': []}
    
    lab_data = parse_lab_file(filepath)
    
    return {'commands': lab_data.get('commands', []) if lab_data else []}


def exit_lab(data):
    """Exit a lab and run cleanup"""
    obj_id = data.get('objective')
    filename = data.get('file')
    
    filepath = resolve_lab_filepath(obj_id, filename)
    
    if filepath and os.path.exists(filepath):
        run_lab_function(filepath, 'cleanup_lab')
    
    return {'success': True}


def send_to_terminal(data):
    """Send a command to the terminal via tmux"""
    command = data.get('command', '')
    press_enter = data.get('pressEnter', False)
    
    if not command:
        return {'error': 'No command provided', 'success': False}
    
    try:
        # Check if tmux session exists
        result = subprocess.run(
            ['tmux', 'has-session', '-t', TMUX_SESSION],
            capture_output=True
        )
        
        if result.returncode != 0:
            return {'error': 'Terminal session not found', 'success': False}
        
        # Send keys to tmux
        subprocess.run(
            ['tmux', 'send-keys', '-t', TMUX_SESSION, command],
            capture_output=True,
            check=True
        )
        
        # Optionally press Enter to execute the command
        if press_enter:
            subprocess.run(
                ['tmux', 'send-keys', '-t', TMUX_SESSION, 'Enter'],
                capture_output=True,
                check=True
            )
        
        return {'success': True}
    except subprocess.CalledProcessError as e:
        return {'error': f'Failed to send command: {e}', 'success': False}
    except FileNotFoundError:
        return {'error': 'tmux not installed', 'success': False}
    except Exception as e:
        return {'error': str(e), 'success': False}


# Version check configuration
VERSION_FILE = "/usr/local/share/rhcsa/.version"
GITHUB_REPO_API = "https://api.github.com/repos/RHCSA/RHCSA.github.io/commits/main"
INSTALLER_URL = "https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh"


def check_version():
    """Check if an update is available"""
    try:
        import urllib.request
        
        # Read installed version
        installed = None
        if os.path.exists(VERSION_FILE):
            with open(VERSION_FILE, 'r') as f:
                installed = f.read().strip()
        
        if not installed:
            return {'updateAvailable': False, 'message': 'Version file not found'}
        
        # Fetch latest version from GitHub
        req = urllib.request.Request(GITHUB_REPO_API, headers={'User-Agent': 'RHCSA-Simulator'})
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read().decode('utf-8'))
            latest = data.get('sha', '')
        
        if not latest:
            return {'updateAvailable': False, 'message': 'Could not fetch latest version'}
        
        # Compare versions
        update_available = installed != latest
        
        return {
            'updateAvailable': update_available,
            'installed': installed[:7] if installed else 'unknown',
            'latest': latest[:7] if latest else 'unknown',
            'installedFull': installed,
            'latestFull': latest
        }
    except Exception as e:
        return {'updateAvailable': False, 'error': str(e)}


def run_update():
    """Run the installer to update"""
    try:
        # Download installer to temp file and run with --force flag
        tmp_installer = '/tmp/rhcsa_webui_update.sh'
        result = subprocess.run(
            ['bash', '-c', f'curl -sL {INSTALLER_URL} -o {tmp_installer} && chmod +x {tmp_installer} && {tmp_installer} --force'],
            capture_output=True,
            text=True,
            timeout=300  # 5 minute timeout
        )
        
        # Cleanup temp file
        try:
            os.remove(tmp_installer)
        except:
            pass
        
        if result.returncode == 0:
            return {'success': True, 'message': 'Update completed successfully'}
        else:
            return {'success': False, 'error': result.stderr or 'Update failed'}
    except subprocess.TimeoutExpired:
        return {'success': False, 'error': 'Update timed out'}
    except Exception as e:
        return {'success': False, 'error': str(e)}


def start_ttyd():
    """Start ttyd terminal server with tmux session"""
    try:
        # Check if ttyd is running
        result = subprocess.run(['pgrep', '-f', f'ttyd.*{TERMINAL_PORT}'], capture_output=True)
        if result.returncode == 0:
            print(f"ttyd already running on port {TERMINAL_PORT}")
            return
        
        # Kill any existing tmux session
        subprocess.run(['tmux', 'kill-session', '-t', TMUX_SESSION], 
                      capture_output=True, stderr=subprocess.DEVNULL)
        
        # Create new tmux session in detached mode
        subprocess.run([
            'tmux', 'new-session', '-d', '-s', TMUX_SESSION, '-c', '/tmp'
        ], check=True)
        
        print(f"Created tmux session: {TMUX_SESSION}")
        
        # Start ttyd attached to the tmux session
        subprocess.Popen([
            'ttyd',
            '-p', str(TERMINAL_PORT),
            '-W',  # Writable
            '-t', 'fontSize=16',
            '-t', 'fontFamily=monospace',
            'tmux', 'attach-session', '-t', TMUX_SESSION
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        print(f"Started ttyd on port {TERMINAL_PORT} with tmux session")
    except FileNotFoundError as e:
        print(f"Warning: Required program not found: {e}. Please install ttyd and tmux.")
    except Exception as e:
        print(f"Error starting ttyd: {e}")


def run_server():
    """Run the web server"""
    server = HTTPServer(('0.0.0.0', WEBUI_PORT), RHCSAAPIHandler)
    print(f"Web server running on port {WEBUI_PORT}")
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down...")
        server.shutdown()


def main():
    """Main entry point"""
    print("RHCSA Web Interface Server")
    print("=" * 40)
    
    # Start ttyd in background
    start_ttyd()
    
    # Run web server
    run_server()


if __name__ == '__main__':
    main()
