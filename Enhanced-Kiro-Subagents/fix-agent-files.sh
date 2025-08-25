#!/bin/bash

# Directory containing the agent files
AGENTS_DIR="$HOME/.claude/agents"

# List of files to skip (they might have different format or purpose)
skip_files="README.md CHANGELOG.md CONTRIBUTING.md UPDATES.md"

# Function to check if string contains substring
contains() {
    string="$1"
    substring="$2"
    if [[ $string == *"$substring"* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if frontmatter has name field
has_name_in_frontmatter() {
    local file_path="$1"
    local in_frontmatter=false
    local frontmatter_end=false
    
    while IFS= read -r line; do
        # Check if we're entering frontmatter
        if [[ $line == "---" ]] && [[ $in_frontmatter == false ]]; then
            in_frontmatter=true
            continue
        fi
        
        # Check if we're exiting frontmatter
        if [[ $line == "---" ]] && [[ $in_frontmatter == true ]]; then
            frontmatter_end=true
            break
        fi
        
        # Check for name field within frontmatter
        if [[ $in_frontmatter == true ]] && [[ $line == name:* ]]; then
            return 0  # Found name field in frontmatter
        fi
    done < "$file_path"
    
    # If we've processed the frontmatter and didn't find a name field
    if [[ $in_frontmatter == true ]] && [[ $frontmatter_end == true ]]; then
        return 1  # No name field in frontmatter
    fi
    
    # If there's no proper frontmatter
    return 2  # No proper frontmatter
}

echo "Processing agent files..."

# Process each .md file in the directory
for file_path in "$AGENTS_DIR"/*.md; do
    # Extract just the filename
    md_file=$(basename "$file_path")
    
    # Skip if in our skip list
    if contains "$skip_files" "$md_file"; then
        echo "Skipping $md_file"
        continue
    fi
    
    # Read the file content
    content=$(head -n 1 "$file_path")
    
    # Check if the file has frontmatter (starts with ---)
    if [[ $content == ---* ]]; then
        # Check if it already has a name field in the frontmatter
        if has_name_in_frontmatter "$file_path"; then
            echo "Skipped $md_file: Already has name field in frontmatter"
        else
            # Extract the name from the filename (without extension)
            name="${md_file%.*}"
            
            # Add the name field to the frontmatter
            # We'll use sed to insert it after the first line
            sed -i '' "2i\\
name: $name\\
" "$file_path"
            
            echo "Fixed $md_file: Added name field '$name'"
        fi
    else
        # File doesn't have frontmatter, add it
        name="${md_file%.*}"
        # Create a temporary file with the new content
        {
            echo "---"
            echo "name: $name"
            echo "---"
            echo ""
            cat "$file_path"
        } > "$file_path.tmp" && mv "$file_path.tmp" "$file_path"
        
        echo "Fixed $md_file: Added frontmatter with name '$name'"
    fi
done

echo "Done!"