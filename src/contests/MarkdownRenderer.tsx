import * as marked from 'marked';
import * as React from 'react';
import * as renderHTML from 'react-render-html';

export interface Props {
  text: string;
}

export default class MarkdownRenderer extends React.Component<Props, {}> {
  private renderer: MarkedRenderer;

  constructor(props: Props) {
    super(props);
    this.renderer = new marked.Renderer();
    this.renderer.em = (str: string) => {
      return '_' + str + '_';
    };
  }

  public componentDidMount() {
    MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
  }
  public componentDidUpdate() {
    MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
  }
  public render() {
    return (
      <div className='markdown-body'>
        { renderHTML(marked(this.props.text, { renderer: this.renderer })) }
      </div>
    );
  }
}
