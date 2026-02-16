#!/usr/bin/env python3
"""
Skill Template Generator

Creates a basic skill structure with SKILL.md template.
Usage: python scripts/create_skill_template.py <skill-name> <description>
"""

import sys
import os
import re

def validate_skill_name(name):
    """Validate skill name follows requirements."""
    if len(name) > 64:
        return False, "Name must be 64 characters or less"
    
    if not re.match(r'^[a-z0-9-]+$', name):
        return False, "Name must contain only lowercase letters, numbers, and hyphens"
    
    if 'anthropic' in name or 'claude' in name:
        return False, "Name cannot contain 'anthropic' or 'claude'"
    
    return True, None

def validate_description(desc):
    """Validate description follows requirements."""
    if not desc or len(desc.strip()) == 0:
        return False, "Description cannot be empty"
    
    if len(desc) > 1024:
        return False, "Description must be 1024 characters or less"
    
    if '<' in desc or '>' in desc:
        return False, "Description cannot contain XML tags"
    
    return True, None

def create_skill_template(skill_name, description, output_dir=None):
    """Create a basic skill structure."""
    # Validate inputs
    valid, error = validate_skill_name(skill_name)
    if not valid:
        return False, f"Invalid skill name: {error}"
    
    valid, error = validate_description(description)
    if not valid:
        return False, f"Invalid description: {error}"
    
    # Determine output directory
    if output_dir is None:
        output_dir = f"skill/{skill_name}"
    
    # Create directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Create title from skill name
    title = ' '.join(word.capitalize() for word in skill_name.split('-'))
    
    # Generate SKILL.md content
    skill_content = f"""---
name: {skill_name}
description: {description}
---

# {title}

[Brief introduction to what this skill does]

## Quick Start

[Most common use case with minimal steps]

```python
# Example code here
pass
```

## Common Operations

### Operation 1

[Step-by-step instructions]

### Operation 2

[Step-by-step instructions]

## Examples

### Example 1: [Scenario Name]

[Complete working example]

```python
# Complete example code
pass
```

## Advanced Usage

[Link to additional documentation if needed]

## Troubleshooting

**Issue**: [Common problem]
**Solution**: [How to fix it]
"""
    
    # Write SKILL.md
    skill_path = os.path.join(output_dir, "SKILL.md")
    with open(skill_path, 'w') as f:
        f.write(skill_content)
    
    return True, f"Skill template created at {output_dir}"

def main():
    if len(sys.argv) < 3:
        print("Usage: python create_skill_template.py <skill-name> <description>")
        print("\nExample:")
        print('  python create_skill_template.py my-skill "Process data using pandas. Use when working with CSV files or data analysis."')
        sys.exit(1)
    
    skill_name = sys.argv[1]
    description = sys.argv[2]
    output_dir = sys.argv[3] if len(sys.argv) > 3 else None
    
    success, message = create_skill_template(skill_name, description, output_dir)
    
    if success:
        print(f"✓ {message}")
        print(f"\nNext steps:")
        print(f"1. Edit {output_dir or f'skill/{skill_name}'}/SKILL.md")
        print(f"2. Add specific instructions and examples")
        print(f"3. Create additional files if needed (references, scripts)")
        print(f"4. Test the skill with example use cases")
    else:
        print(f"✗ {message}")
        sys.exit(1)

if __name__ == "__main__":
    main()
