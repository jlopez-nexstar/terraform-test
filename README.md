# Terraform CI with Accurate Plan Detection in GitHub Actions

This repository demonstrates a fully working example of using **Terraform's exit codes** to control the flow of a CI pipeline in **GitHub Actions**, enabling:

- ✅ Automatic detection of infrastructure changes using `terraform plan -detailed-exitcode`
- ✅ Conditional execution of `terraform apply` **only when changes are detected**
- ✅ Safe gating of apply using [GitHub Environment Protection Rules](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

---

## 📌 Background

Terraform’s `plan` command can return **3 different exit codes**:

| Exit Code | Meaning                          |
|-----------|----------------------------------|
| `0`       | No changes                       |
| `1`       | Error occurred                   |
| `2`       | Changes detected (safe to apply) |

However, many CI setups **fail to capture exit code `2`** properly due to:

- Misuse of `set -e` or `continue-on-error`
- Incorrect attempts to capture `$?` in shell scripts
- Reliance on `steps.<id>.outcome` which only shows `"success"` or `"failure"` — **not the numeric exit code**

That said we end up with the following limitations:
- Manual exit code parsing
- set +e shell tricks
- Inconsistent behavior across runners
---

## 🚀 How It Works

This setup works because it captures the exit code **natively from the job step**, using GitHub’s built-in output propagation:

First, we execute the `terraform plan` command with the `-detailed-exitcode` flag in a job step to capture the exit code so we can evaluate depending of the value as mentioned above:

```yaml
- id: plan
  run: terraform plan -detailed-exitcode -out=tf.plan
```

Then pass the exit code as an output from the job:

```yaml
outputs:
  changes: ${{ steps.plan.outputs.exitcode }}
```
And finally a conditional check in the next job with approval gate:

```yaml
if: needs.terraform-plan.outputs.changes == '2'
```

### Workflow Structure

#### `terraform-plan` job

- Runs `terraform init` and `terraform plan`
- Captures `exitcode` from the plan step
- Uploads the generated plan file (`tf.plan`)
- Exposes `changes` output (set to `2` only if changes were detected)

#### `terraform-apply` job

- Triggered only if `exitcode == 2`
- Uses a GitHub-protected environment (e.g., `test`) to require approval
- Downloads and applies the saved `tf.plan`

---

## 🔐 GitHub Environment Setup

To enforce manual approvals before applying infrastructure changes:

1. Go to **Repository → Settings → Environments**
2. Create an environment (e.g., `test`)
3. Add **required reviewers**
4. *(Optional)* Add **secrets** or **branch protections**



## 🤝 Contributing
Feel free to fork, open issues, or suggest improvements — especially if you're using different backends, modules, or pipeline tools.

## 📜 License
MIT – use it, adapt it, break it, improve it.

## 💡 Credits
Thanks to the Terraform community and CI/CD engineers who dig deep to make automation reliable.
