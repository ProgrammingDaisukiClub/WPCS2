import * as marked from 'marked';
import * as React from 'react';

export interface Props {
  text: string;
}

export default class MarkdownRender extends React.Component<Props, {}> {
  private markup() {
    return {__html: marked(this.props.text)};
  }
  public componentDidMount() {
    MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
  }
  public render() {
    return (
      <div dangerouslySetInnerHTML={ this.markup() } className='markdown-body' />
    );
  }
}
