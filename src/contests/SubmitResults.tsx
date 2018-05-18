import * as React from 'react';

import SubmissionObject from 'contests/SubmissionObject';

import JUDGE_STATUS from 'contests/JUDGE_STATUS';

export interface SubmitResultsProps extends React.Props<SubmitResults> {
  submissions: SubmissionObject[];
  submitResults: number[];
  closeSubmitResults(): void;
}

export default class SubmitResults extends React.Component<SubmitResultsProps> {
  constructor(props: SubmitResultsProps) {
    super(props);
    this.state = {};
  }

  public results(): SubmissionObject[] {
    return this.props.submissions.filter((submission: SubmissionObject) => {
      return this.props.submitResults.includes(submission.id);
    });
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

  public onCloseClick(): void {
    this.props.closeSubmitResults();
  }

  public render(): JSX.Element {
    if (this.results().length === 0) {
      return null;
    }

    return (
      <div className="submitResults">
        <div className="submitResults--inner">
          <div className="submitResults--header">{t('judge_results')}</div>
          {this.results().map((submission: SubmissionObject) => (
            <div key={submission.id} className="submitResults--item">
              <span className="submitResults--date">{this.createdAt(submission.createdAt)}</span>
              <span className={`submitResults--judgeStatus__${this.judgeStatus(submission.judgeStatus)}`}>
                {this.judgeStatus(submission.judgeStatus)}
              </span>
              {submission.judgeStatus !== JUDGE_STATUS.WJ && (
                <span className="submitResults--score">
                  {submission.score}
                  {t('point')}
                </span>
              )}
            </div>
          ))}
          <div className="submitResults--footer">
            <span role="button" className="submitResults--close" onClick={this.onCloseClick.bind(this)}>
              {t('close')}
            </span>
          </div>
        </div>
      </div>
    );
  }
}
