interface ReactRenderHtml {
  (html: string): any;
}

declare module 'react-render-html' {
  export = renderHTML;
}

declare var renderHTML: ReactRenderHtml;
