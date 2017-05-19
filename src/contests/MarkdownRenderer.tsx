import * as marked from 'marked';
import * as React from 'react';
import * as renderHTML from 'react-render-html';

interface Katex {
  renderToString: any;
}
declare var katex: Katex;

export interface Props {
  text: string;
}

export default class MarkdownRenderer extends React.Component<Props, {}> {
  private renderer: MarkedRenderer;

  constructor(props: Props) {
    super(props);
    this.renderer = new marked.Renderer();
    this.renderer.code = (str: string) => {
      return '<div class="markdown--code">' + str.replace(/\n/g, "<br/>") + '</div>' ;
    };
    marked.setOptions({ renderer: this.renderer });
  }

  private renderKatexFragments(text: string): string {
    const items = text.split("$");
    let result = "";
    for (let i = 0; i < items.length; i++) {
      result += i % 2 == 0 ? items[i] : katex.renderToString(items[i]);
    }
    return result;
  }

  public render() {
    return (
      <div className='markdown-body'>
        { renderHTML(marked(this.renderKatexFragments(this.props.text))) }
      </div>
    );
  }
}
