import * as React from 'react';

import MarkdownRenderer from 'contests/MarkdownRenderer';

export default class ProblemStatementParseTest extends React.Component<{}, {}> {
  public render() {
    return (
      <div>
        <MarkdownRenderer text='# This is a test header\n\nthis is a **test** *content*.' />
        <MarkdownRenderer text='日本語もおｋ\n\n\n\n* One\n* Two\n* Three' />
        <MarkdownRenderer text=
        'Rendering mathmatical notations like $1 \\leq a_n, b_n \\leq 10^{5}$ is supported by using Mathjax.' />
        <MarkdownRenderer text=
        '| T | A | B | L | E |\n|--|--|--|--|--|\n| hoge | piyo | fuga | a | a |\n| a | b | c | d | e |' />
      </div>
    );
  }
}
