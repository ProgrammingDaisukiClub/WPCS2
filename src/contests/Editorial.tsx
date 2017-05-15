import * as React from 'react';

import EditorialObject from 'contests/EditorialObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface EditorialProps {
  editorial: EditorialObject;
}

export default class Editorial extends React.Component<EditorialProps, {}> {
  constructor() {
    super();
    this.state = {};
  }

  public render() {
    return (
      <div className="editorial">
        <div className="editorial--inner">
          <h2 className="editorial--header">Editorial</h2>
          <div className="editorial--body">
            <div className="editorial--content">
              <div className="editorial--content">
                <MarkdownRenderer text= { this.props.editorial.content } />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
