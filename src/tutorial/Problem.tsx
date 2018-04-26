import * as React from 'react';

export interface Props {
  params: {
    problemId: string;
  };
}

export default class Problem extends React.Component<Props> {
  public render(): JSX.Element {
    return <div>Problem{this.props.params.problemId}</div>;
  }
}
