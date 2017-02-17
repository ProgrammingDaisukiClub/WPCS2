import * as React from 'react';

/**
 * An interface for representing the properties of MyComponent.
 */
export interface Props {
  content: string;
}

/**
 * A class of a sample react component.
 */
export default class MyComponent extends React.Component<Props, {}> {
  public render() {
    return <div>{ this.props.content } - React Tutorial by ShinyaKato</div>;
  }
}
