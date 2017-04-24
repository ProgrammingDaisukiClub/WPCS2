import * as React from 'react';
import * as ReactDOM from 'react-dom';
import MarkdownRenderer from 'contests/MarkdownRenderer';

ReactDOM.render(
  <MarkdownRenderer text= { document.getElementById('description_ja').innerHTML } />,
  document.getElementById('description_ja')
);
ReactDOM.render(
  <MarkdownRenderer text= { document.getElementById('description_en').innerHTML } />,
  document.getElementById('description_en')
);
