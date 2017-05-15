import * as React from 'react';

import EditorialObject from 'contests/EditorialObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface EditorialProps {
  editorial: EditorialObject;
}

// export interface EditorialState {
//   dataSetTabId: number;
// }

export default class Editorial extends React.Component<EditorialProps, {}> {
  constructor() {
    super();
    this.state = {};
  }

  public render() {
    return (
      <div className="problem">
        <div className="problem--inner">
          <h2 className="problem--header">Editorial</h2>
          <div className="problem--body">
            <div className="problem--description">
              <div className="problem--descriptionBody">
                <MarkdownRenderer text= { this.props.editorial.content } />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
