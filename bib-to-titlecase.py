#!/usr/bin/env python
#
# Original by Daniel L. Greenwald
# http://dlgreenwald.weebly.com/blog/capitalizing-titles-in-bibtex
# Modified by Garrett Dash Nelson
# https://gist.github.com/garrettdashnelson/af0f8307393da37c6f94eda8c4613a4f
#
# Modified by Manuel Olguín Muñoz
import io
import re
from collections import deque
from typing import Sequence

import click as click
from titlecase import titlecase

# Match title, Title, booktitle, Booktitle fields
pattern = re.compile(r'(\W*)([Bb]ook)?([Tt]itle = {+)(.*)(}+,)')


class LineError(Exception):
    def __init__(self, num: int, line: str):
        super().__init__(f"Error in line num {num:d} (line: \"{line}\")")


def to_titlecase(lines: Sequence[str]) -> Sequence[str]:
    # Search for title strings and replace with titlecase
    new_lines = deque()
    for line_num, line in enumerate(lines):
        # Check if line contains title
        match_obj = pattern.match(line)
        if match_obj is not None:
            try:
                # Need to "escape" any special chars to avoid misinterpreting them in the regular expression.
                old_title = re.escape(match_obj.group(4))

                # Apply titlecase to get the correct title.
                new_title = titlecase(match_obj.group(4))

                # Replace and add to list
                p_title = re.compile(old_title)
                newline = p_title.sub(new_title, line)
            except Exception as e:
                raise LineError(line_num, line) from e

            new_lines.append(newline)
        else:
            # If not title, add as is.
            new_lines.append(line)

    return new_lines


@click.command
@click.argument("input-file", type=click.File())
@click.option("-o", "--output-file", type=click.File(mode="w", lazy=True, atomic=True), default="-", show_default=True)
def main(input_file: io.StringIO, output_file: io.StringIO):
    output_file.writelines(to_titlecase(input_file.readlines()))


if __name__ == '__main__':
    main()
