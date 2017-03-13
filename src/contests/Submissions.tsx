import * as React from 'react';
import { Link } from 'react-router';

import ContestObject from 'contests/ContestObject';
import ProblemObject from 'contests/ProblemObject';
import DataSetObject from 'contests/DataSetObject';
import SubmissionObject from 'contests/SubmissionObject';

export interface SubmissionsProps extends React.Props<Submissions> {
  contest: ContestObject;
  submissions: [ SubmissionObject ];
}

export default class Submissions extends React.Component<SubmissionsProps, {}> {
  constructor() {
    super();
    this.state = {};
  }

  public createdAt(date: Date) {
    const yyyy: number = date.getFullYear();
    const mm: number = date.getMonth() + 1;
    const dd: number = date.getDate();
    const HH: number = date.getHours();
    const MM: number = date.getMinutes();
    const SS: number = date.getSeconds();
    return `${yyyy}/${mm < 10 ? '0' : ''}${mm}/${dd < 10 ? '0' : ''}${dd} ${HH < 10 ? '0' : ''}${HH}:${MM < 10 ? '0' : ''}${MM}:${SS < 10 ? '0' : ''}${SS}`;
  }

  public problemName(problemId: number) {
    const name: string = this.props.contest.problems.find((problem: ProblemObject) => {
      return problem.id === problemId;
    }).name;

    return <Link to={ `/contests/${this.props.contest.id}/problems/${problemId}` }>{ name }</Link>
  }

  public dataSetLabel(problemId: number, dataSetId: number) {
    return this.props.contest.problems.find((problem: ProblemObject) => {
      return problem.id === problemId;
    }).dataSets.find((dataSet: DataSetObject) => {
      return dataSet.id === dataSetId;
    }).label;
  }

  public render() {
    const WA: number = 1;

    return (
      <div className="submissions">
        <div className="submissions--inner">
          <div className="submissions--header">Submissions</div>
          <div className="submissions--body">
            <table className="submissions--table">
              <thead>
                <tr>
                  <td className="submissions--createdAtHeader">提出日時</td>
                  <td className="submissions--problemNameHeader">問題名</td>
                  <td className="submissions--dataSetLabelHeader">データセット</td>
                  <td className="submissions--judgeStatusHeader">判定</td>
                  <td className="submissions--scoreHeader">得点</td>
                </tr>
              </thead>
              <tbody>
                { this.props.submissions.map((submission) => (
                  <tr key={ submission.id }>
                    <td className="submissions--createdAt">{ this.createdAt(submission.createdAt) }</td>
                    <td className="submissions--problemName">{ this.problemName(submission.problemId) }</td>
                    <td className="submissions--dataSetLabel">{ this.dataSetLabel(submission.problemId, submission.dataSetId) }</td>
                    <td className="submissions--judgeStatus">
                      <div className={ `submissions--judgeStatusBadge__${ submission.judgeStatus === WA ? 'WA' : 'AC' }` }>
                        { submission.judgeStatus === WA ? 'WA' : 'AC' }
                      </div>
                    </td>
                    <td className="submissions--score">{ submission.score }</td>
                  </tr>
                )) }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
}
