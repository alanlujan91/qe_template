def combine_files(file_paths):
    combined_content = []
    
    for path in file_paths:
        try:
            with open(path, 'r') as file:
                # Add file name as first line
                combined_content.append(path)
                # Add file contents
                combined_content.append(file.read().strip())
                # Add separator
                combined_content.append('---\n')
        except FileNotFoundError:
            print(f"Warning: Could not find file {path}")
        except Exception as e:
            print(f"Error processing file {path}: {e}")
    
    # Write combined content to new file
    try:
        with open('combined_output.txt', 'w') as output_file:
            output_file.write('\n'.join(combined_content))
        print("Successfully created combined_output.txt")
    except Exception as e:
        print(f"Error writing output file: {e}")

# Example usage
file_paths = [
    'template.yml', 
    'template.tex', 
    'sample/sample.md',
    'sample/appendix.md',
    'sample/sample_pdf_tex/sample.tex',
    'original/qe_sample.tex',
]

combine_files(file_paths)