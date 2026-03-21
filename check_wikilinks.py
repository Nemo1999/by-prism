#!/usr/bin/env python3
import os
import re
import sys

def extract_wikilinks(content):
    # pattern matches [[...]] and can handle nested brackets? but wikilinks usually don't nest
    pattern = r'\[\[(.*?)\]\]'
    return re.findall(pattern, content)

def check_wikilink(wikilink):
    # split by pipe to get target and display text
    if '|' in wikilink:
        target, display = wikilink.split('|', 1)
    else:
        target = wikilink
        display = None
    # remove any anchor # part
    target = target.split('#')[0]
    # check if target starts with posts/
    if target.startswith('posts/'):
        return True, target, 'has posts/ prefix'
    else:
        return False, target, 'missing posts/ prefix'

def main():
    root = 'src/content'
    all_links = []
    errors = []
    for dirpath, dirnames, filenames in os.walk(root):
        for fname in filenames:
            if fname.endswith('.md'):
                path = os.path.join(dirpath, fname)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                links = extract_wikilinks(content)
                for link in links:
                    ok, target, msg = check_wikilink(link)
                    all_links.append((path, link, ok, target, msg))
                    if not ok:
                        errors.append((path, link, target))
    print(f"Total wikilinks found: {len(all_links)}")
    print(f"Errors (missing posts/ prefix): {len(errors)}")
    print("\n--- Random sample of 10 wikilinks ---")
    import random
    sample = random.sample(all_links, min(10, len(all_links)))
    for path, link, ok, target, msg in sample:
        status = "✓" if ok else "✗"
        print(f"{status} {path}: [[{link}]] -> {msg}")
    print("\n--- First 10 errors ---")
    for i, (path, link, target) in enumerate(errors[:10]):
        print(f"{i+1}. {path}: [[{link}]] (target: {target})")
    print("\n--- Checking for non-ASCII filenames in wikilinks ---")
    non_ascii = []
    for path, link, ok, target, msg in all_links:
        # extract filename from target (last part)
        # target might be like posts/japanese-learning/grammar/naraba-hypothetical-condition
        # we need to check if the filename part contains non-ASCII
        if target:
            # split by / and get last part
            parts = target.split('/')
            if parts:
                filename = parts[-1]
                # check if filename contains non-ASCII characters
                if filename and not all(ord(c) < 128 for c in filename):
                    non_ascii.append((path, link, filename))
    print(f"Non-ASCII filenames in wikilinks: {len(non_ascii)}")
    for path, link, filename in non_ascii[:10]:
        print(f"  {path}: [[{link}]] -> {filename}")
    # Also check for Chinese characters in target
    # Return exit code
    if errors or non_ascii:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main()