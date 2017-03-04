import * as marked from 'marked';
import * as React from 'react';
import * as renderHTML from 'react-render-html';

export interface Props {
  text: string;
}

export default class MarkdownRender extends React.Component<Props, {}> {
  public componentDidMount() {
    MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
  }
  public render() {
    return (
      <div className='markdown-body'>
        { renderHTML(marked(this.props.text)) }
      </div>
    );
  }
}
