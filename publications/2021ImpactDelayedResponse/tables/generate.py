#!/usr/bin/env python3
import shutil
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Collection, IO

import click
import jinja2


def generate_table_texs(template_str: str, tables: Collection[str]) \
        -> Collection[str]:
    latex_jinja_env = jinja2.Environment(
        block_start_string='\BLOCK{',
        block_end_string='}',
        variable_start_string='\VAR{',
        variable_end_string='}',
        comment_start_string='\#{',
        comment_end_string='}',
        line_statement_prefix='%%',
        line_comment_prefix='%#',
        trim_blocks=True,
        autoescape=False)
    temp = latex_jinja_env.from_string(template_str)
    return list(map(lambda t: temp.render(table=t), tables))


@click.command()
@click.argument('template', nargs=1, type=click.File())
@click.argument('output_dir', nargs=1,
                type=click.Path(exists=True, file_okay=False,
                                dir_okay=True, resolve_path=True))
@click.argument('tables', nargs=-1,
                type=click.Path(exists=True, file_okay=True,
                                dir_okay=False, resolve_path=True))
def generate(template: IO, output_dir: str, tables: Collection[str]):
    template_str = template.read()
    tab_str = []
    tab_names = []
    for table in tables:
        tab_path = Path(table)
        with tab_path.open('r') as fp:
            tab_str.append(fp.read())
        tab_names.append(tab_path.name)

    output_dir = Path(output_dir).resolve()
    texs = generate_table_texs(template_str, tab_str)
    # make temp dir
    with TemporaryDirectory() as tmp_dir_str:
        tmp_dir = Path(tmp_dir_str).resolve()
        for tex, table_name in zip(texs, tab_names):
            tex_file_path = (tmp_dir / table_name).resolve()
            with tex_file_path.open('w') as fp:
                fp.write(tex)

            for i in range(4):
                subprocess.Popen([
                    '/usr/bin/latexmk',
                    '-interaction=nonstopmode',
                    '-shell-escape',
                    '-synctex=1',
                    '-f',
                    f'-jobname={table_name}',
                    f'-output-directory={tmp_dir}',
                    f'{tex_file_path}'
                ], cwd=str(tmp_dir)).wait()

        for f in tmp_dir.iterdir():
            if f.name.endswith('png'):
                shutil.move(str(f.resolve()),
                            str((output_dir / f.name).resolve()))


if __name__ == '__main__':
    generate()
