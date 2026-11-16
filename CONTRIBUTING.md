# Contributing

Thank you for your help.

1. **Fork** this repository on GitHub.
2. **Clone** your fork and **create a branch**:

   ```bash
   git clone https://github.com/<your-user>/RHCSA.github.io.git
   cd RHCSA.github.io
   git checkout -b fix/<short-name>
   ```

3. **Make your change.** For lab and question files, follow [questions/README.md](RHCSA_EX200_Exam_Simulator/questions/README.md).
4. **Test it** on a Rocky Linux 10 VM with the simulator installed. Copy your changed files into `/usr/local/share/rhcsa/` (same folders). For web UI files, run `systemctl restart rhcsa-webui`.
5. **Push** your branch and open a **Pull Request** to `main`. Tell us the problem, the fix and how you tested it.

**Rules**

- One topic in each pull request.
- A lab must not change the disk that holds `/`, and must clean up after itself.
- In `TASK_N_COMMAND_N`, write a literal `$` as `\$`.

Questions? Use [Discussions](https://github.com/RHCSA/RHCSA.github.io/discussions) or [Issues](https://github.com/RHCSA/RHCSA.github.io/issues).
