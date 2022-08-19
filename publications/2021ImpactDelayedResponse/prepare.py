import shutil
import subprocess
from dataclasses import dataclass
from io import StringIO
from pathlib import Path
from typing import Iterator, Tuple

import click
import parse


class Figure:
    @dataclass
    class SubFig:
        sub_index: str
        line: int
        original_path: str

    def __init__(self,
                 index: int):
        self._index = f'Fig{index}'
        self._subfigs = []

    def iterfigs(self) -> Iterator[Tuple[int, str, str]]:
        n_subfigs = len(self._subfigs)
        if n_subfigs == 1:
            sfig = self._subfigs[0]
            yield sfig.line, self._index, sfig.original_path
        elif n_subfigs > 1:
            for sfig in self._subfigs:
                yield sfig.line, \
                      f'{self._index}{sfig.sub_index}', \
                      sfig.original_path
        else:
            raise RuntimeError()

    def add_subfig(self, line: int, graphics: str) -> None:
        sub_index = chr(ord('a') + len(self._subfigs))
        self._subfigs.append(Figure.SubFig(sub_index, line, graphics))

    def __str__(self) -> str:
        n_subfigs = len(self._subfigs)
        if n_subfigs == 1:
            return f'{self._index} {self._subfigs[0].original_path}'
        elif n_subfigs > 1:
            return '\n'.join([f'{self._index}{s.sub_index} '
                              f'{s.original_path}' for s in self._subfigs])
        else:
            raise RuntimeError()


class DirectoryPath(click.ParamType):
    name = 'directory'

    def __init__(self, clean: bool = False,
                 exist_ok: bool = True,
                 parents: bool = False):
        super(DirectoryPath, self).__init__()
        self._clean = clean
        self._exist_ok = exist_ok
        self._parents = parents

    def convert(self, value, param, ctx) -> Path:
        p = Path(value).resolve()
        if self._clean and p.exists():
            subprocess.run(['rm', '-rf', str(p)])

        p.mkdir(exist_ok=self._exist_ok, parents=self._parents)
        return p


@click.command()
@click.option('--cls-file',
              required=False,
              default='./plos2015.bst',
              show_default=True,
              type=click.Path(exists=True, file_okay=True, dir_okay=False))
@click.option('--bib-file',
              required=False,
              default='./bibliography.bib',
              show_default=True,
              type=click.Path(exists=True, file_okay=True, dir_okay=False))
@click.option('--graphics/--no-graphics',
              required=False,
              default=True,
              show_default=True,
              help='Include/don\'t include graphics in the .tex file.')
@click.argument('tex_file',
                required=True,
                type=click.File('r'))
@click.argument('output_dir',
                required=True,
                type=DirectoryPath(clean=True, exist_ok=True, parents=True))
def main(cls_file: str,
         bib_file: str,
         tex_file: StringIO,
         output_dir: Path,
         graphics: bool = True):
    figs = []
    current_figure_index = 0
    current_fig = None
    tex_lines = list(tex_file)

    # outputs
    tex_output = output_dir / 'paper.tex'
    shutil.copy(cls_file, output_dir)
    shutil.copy(bib_file, output_dir)

    click.echo('Parsing .tex document...')
    for i, line in enumerate(tex_lines):
        if line.startswith('%'):
            continue
        elif '\\begin{figure}' in line or '\\begin{figure*}' in line:
            current_figure_index += 1
            current_fig = Figure(current_figure_index)
        elif '\\end{figure}' in line or '\\end{figure*}' in line:
            figs.append(current_fig)
        elif '\\includegraphics' in line:
            cleaned = line.strip()
            parsed = parse.parse(
                '\\includegraphics[{}]{fname}', cleaned)
            filename = parsed['fname'][1:-1].strip()
            current_fig.add_subfig(i, filename)

    subprocs = []
    click.echo('Processing figures and graphics...')
    for f in figs:
        for linenumber, new_name, old_name in f.iterfigs():
            click.echo(f'{old_name} -> {new_name}')

            output_target = output_dir / f'{new_name}.eps'
            if old_name.endswith('.pdf'):
                # instead of copying, convert and output to correct dir
                subproc = subprocess.Popen(['/usr/bin/pdf2ps',
                                            f'{old_name}',
                                            output_target])
                subprocs.append(subproc)
            elif old_name.endswith('.eps'):
                shutil.copy(old_name, output_target, follow_symlinks=True)

            tex_lines[linenumber] = \
                ('' if graphics else '% ') + tex_lines[linenumber].replace(
                    old_name, output_target.name)

    for sproc in subprocs:
        sproc.wait()

    with tex_output.open('w') as fp:
        fp.writelines(tex_lines)


if __name__ == '__main__':
    main()
