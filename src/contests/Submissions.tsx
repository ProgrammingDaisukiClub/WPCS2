import * as React from 'react';
import { Link } from 'react-router';

import ContestObject from 'contests/ContestObject';
import DataSetObject from 'contests/DataSetObject';
import ProblemObject from 'contests/ProblemObject';
import SubmissionObject from 'contests/SubmissionObject';

import JUDGE_STATUS from 'contests/JUDGE_STATUS';

export interface SubmissionsProps extends React.Props<Submissions> {
  contest: ContestObject;
  submissions: SubmissionObject[];
}

export default class Submissions extends React.Component<SubmissionsProps> {
  constructor() {
    super();
    this.state = {};
  }

  public createdAt(date: Date): string {
    const yyyy: number = date.getFullYear();
    const mm: number = date.getMonth() + 1;
    const dd: number = date.getDate();
    const HH: number = date.getHours();
    const MM: number = date.getMinutes();
    const SS: number = date.getSeconds();

    return `${yyyy}/${mm < 10 ? '0' : ''}${mm}/${dd < 10 ? '0' : ''}${dd} ${HH < 10 ? '0' : ''}${HH}:${
      MM < 10 ? '0' : ''
    }${MM}:${SS < 10 ? '0' : ''}${SS}`;
  }

  public problemName(problemId: number): JSX.Element {
    const name: string = this.props.contest.problems.find((problem: ProblemObject) => {
      return problem.id === problemId;
    }).name;

    return <Link to={`/contests/${this.props.contest.id}/problems/${problemId}`}>{name}</Link>;
  }

  public dataSetLabel(problemId: number, dataSetId: number): string {
    return this.props.contest.problems
      .find((problem: ProblemObject) => {
        return problem.id === problemId;
      })
      .dataSets.find((dataSet: DataSetObject) => {
        return dataSet.id === dataSetId;
      }).label;
  }

  public judgeStatus(status: number): string {
    switch (status) {
      case JUDGE_STATUS.WJ:
        return 'WJ';
      case JUDGE_STATUS.WA:
        return 'WA';
      case JUDGE_STATUS.AC:
        return 'AC';
      default:
    }
  }

  public render(): JSX.Element {
    return (
      <div className="submissions">
        <div className="submissions--inner">
          <div className="submissions--header">{t('submissions')}</div>
          <div className="submissions--body">
            <table className="submissions--table">
              <thead>
                <tr>
                  <td className="submissions--createdAtHeader">{t('submitted_at')}</td>
                  <td className="submissions--problemNameHeader">{t('problem')}</td>
                  <td className="submissions--dataSetLabelHeader">{t('data_set')}</td>
                  <td className="submissions--judgeStatusHeader">{t('judge')}</td>
                  <td className="submissions--scoreHeader">{t('score')}</td>
                </tr>
              </thead>
              <tbody>
                {this.props.submissions.map((submission: SubmissionObject) => (
                  <tr key={submission.id}>
                    <td className="submissions--createdAt">{this.createdAt(submission.createdAt)}</td>
                    <td className="submissions--problemName">{this.problemName(submission.problemId)}</td>
                    <td className="submissions--dataSetLabel">
                      {this.dataSetLabel(submission.problemId, submission.dataSetId)}
                    </td>
                    <td className="submissions--judgeStatus">
                      <div className={`submissions--judgeStatusBadge__${this.judgeStatus(submission.judgeStatus)}`}>
                        {this.judgeStatus(submission.judgeStatus)}
                      </div>
                    </td>
                    <td className="submissions--score">
                      {submission.judgeStatus !== JUDGE_STATUS.WJ && submission.score}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }
}
