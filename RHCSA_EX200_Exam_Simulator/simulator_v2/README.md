# RHCSA Simulator v2 Scaffold

This scaffold is additive and backward-compatible. It does not replace the existing `rhcsa` runner.

Added in this code drop:

- `questions/3/` with 30 Shell Scripting labs
- `simulator_v2/core/` helper runners for isolated prepare/validate/cleanup testing
- `simulator_v2/question_catalog_chapter03.yaml`

The existing simulator can still load the new questions because they follow the current `IS_LAB`, `prepare_lab`, `check_tasks`, `cleanup_lab` format.
