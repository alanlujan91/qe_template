# Contributing to QE MyST Template

Thank you for your interest in contributing to the Quantitative Economics MyST Template!

## Development Setup

### Prerequisites

- Python with `uv` package manager
- Node.js with `npm` (for MyST)
- LaTeX distribution (TeX Live or similar)
- Git with submodules support

### Clone the Repository

This repository uses a git submodule to track the official QE LaTeX template:

```bash
git clone --recurse-submodules https://github.com/alanlujan91/qe_template.git
cd qe_template
```

If you already cloned without submodules:

```bash
git submodule update --init --recursive
```

### Install Development Tools

```bash
# Install MyST
npm install -g mystmd
# or
uv tool install mystmd

# Install pre-commit
uv tool install pre-commit

# Enable pre-commit hooks
pre-commit install
```

## Quality Assurance

### Pre-commit Hooks

Pre-commit hooks run automatically before each commit to catch issues early.

**What gets checked**:

- ✅ Template structure validation (`jtex check`)
- ✅ Sample PDF compilation
- ✅ File existence verification
- ✅ Thumbnail presence
- ✅ ASCII-only source files (no unicode/smart quotes)
- ✅ Whitespace/line ending fixes

**Manual commands**:

```bash
# Run all hooks on all files
pre-commit run --all-files

# Auto-fix template.yml packages
pre-commit run jtex-autofix --hook-stage manual
```

### Continuous Integration

GitHub Actions run automatically on every push and pull request.

| Job                       | Purpose                                                          |
| ------------------------- | ---------------------------------------------------------------- |
| **validate-template**     | Validates `template.yml`, checks files exist, verifies thumbnail |
| **build-sample**          | Compiles sample PDF, uploads artifact                            |
| **test-template-options** | Tests `draft` and `final` modes with matrix build                |
| **check-ascii**           | Ensures no unicode in source files                               |

View results: [Actions tab](../../actions)

### Local Testing

Preview the website locally:

```bash
myst start
```

Build sample PDF manually:

```bash
myst build sample/qe_sample.md --pdf
```

Run specific validation:

```bash
# Validate template structure
npx jtex check

# Check for unicode/smart quotes
grep -P "[^\x00-\x7F]" sample/*.md
```

## Upstream Synchronization

This template tracks the [official QE LaTeX files](https://github.com/vtex-soft/texsupport.econometricsociety-qe) via git submodule.

### Automatic Updates

A GitHub Action checks for upstream changes every Monday at 9 AM UTC:

1. Updates the `original/` submodule to latest commit
2. Copies updated files: `econsocart.cls`, `econsocart.cfg`, `qe.bst`
3. Creates a pull request with version information
4. Labels the PR as `dependencies` and `automated`

**Manual trigger**: Navigate to [Actions → Sync Upstream](../../actions/workflows/sync-upstream-template.yml) and click "Run workflow"

**Review required**: All updates go through pull requests before merging to ensure no breaking changes.

### Manual Sync Process

If you need to manually sync with upstream:

```bash
# Update submodule
cd original
git pull origin master
cd ..

# Copy updated files
cp original/econsocart.cls .
cp original/econsocart.cfg .
cp original/qe.bst .

# Test the changes
myst build sample/qe_sample.md --pdf

# Commit if successful
git add original econsocart.cls econsocart.cfg qe.bst
git commit -m "chore: sync with upstream QE template"
```

## Making Changes

### Template Files

When modifying template files:

1. **`template.tex`**: Main template with Jinja2 syntax
   - Test with both `draft` and `final` options
   - Ensure all placeholders work correctly
2. **`template.yml`**: Template configuration
   - Run `jtex check` after changes
   - Use `jtex check --fix` to auto-add missing packages
3. **Class files**: Only update from upstream, don't modify directly
   - `econsocart.cls`, `econsocart.cfg`, `qe.bst`

### Sample Document

The sample document demonstrates all template features:

- **`sample/qe_sample.md`**: Main sample document
- **`sample/appendix.md`**: Appendix example
- **`sample/references.bib`**: Bibliography example

**Important**: Keep `qe_sample.md` in sync with the original `original/qe_sample.tex` as much as possible.

### Documentation

- **`README.md`**: User-facing template documentation
- **`.github/CONTRIBUTING.md`**: This file (contributor documentation)
- **Workflow files**: Document changes inline with comments

## Workflow Files

### `.pre-commit-config.yaml`

Defines pre-commit hooks. Each hook includes:
- Description comment
- Purpose and usage
- Any special configuration

### `.github/workflows/ci.yml`

Main CI workflow. Tests:
- Template validation
- PDF builds
- Template options (draft/final)
- ASCII compliance

### `.github/workflows/sync-upstream-template.yml`

Automated upstream synchronization:
- Scheduled: Weekly (Monday 9 AM UTC)
- Manual: On-demand via Actions tab
- Creates PR when updates found

## Troubleshooting

### Common Issues

**LaTeX compilation fails**:
- Check for unicode/smart quotes: `grep -P "[^\x00-\x7F]" sample/*.md`
- Verify all `\begin{}` have matching `\end{}`
- Ensure bibliography file exists and is valid

**Template validation fails**:
- Run `jtex check` for detailed errors
- Use `jtex check --fix` to auto-fix package issues
- Check that all files in `template.yml` exist

**Pre-commit hooks fail**:
- Read the error message carefully
- Many hooks auto-fix issues (trailing whitespace, line endings)
- Run `pre-commit run --all-files` to see all issues

**PDF has incorrect output**:
- Check for curly apostrophes (') instead of backslashes (\)
- Verify raw LaTeX blocks use proper syntax
- Test locally with `myst build sample/qe_sample.md --pdf`

## Pull Request Guidelines

1. **Create a feature branch**: `git checkout -b feature/your-feature-name`
2. **Make your changes**: Follow the guidelines above
3. **Run tests**: `pre-commit run --all-files`
4. **Build sample**: `myst build sample/qe_sample.md --pdf`
5. **Commit**: Write clear commit messages
6. **Push**: `git push origin feature/your-feature-name`
7. **Open PR**: Describe your changes clearly

### Commit Message Format

Use conventional commit format:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `chore:` Maintenance tasks
- `ci:` CI/CD changes
- `refactor:` Code refactoring

Example:
```
fix: correct apostrophe handling in sample document

Replaced 116 curly apostrophes with backslashes in qe_sample.md
to prevent LaTeX command corruption.
```

## Code of Conduct

- Be respectful and constructive
- Follow the existing code style
- Test your changes thoroughly
- Document new features
- Keep discussions focused on the template

## Getting Help

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **MyST Documentation**: [mystmd.org](https://mystmd.org)
- **QE Journal**: [qeconomics.org](https://qeconomics.org/)

## License

By contributing, you agree that your contributions will be licensed under the CC-BY-4.0 License.

