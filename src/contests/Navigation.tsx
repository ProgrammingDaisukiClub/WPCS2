import * as React from 'react';
import { Link } from 'react-router-dom';

import ContestObject from 'contests/ContestObject';
import DataSetObject from 'contests/DataSetObject';
import ProblemObject from 'contests/ProblemObject';

export interface NavigationProps extends React.Props<Navigation> {
  contest: ContestObject;
}

export default class Navigation extends React.Component<NavigationProps> {
  constructor(props: NavigationProps) {
    super(props);
    this.state = {};
  }

  public render(): JSX.Element {
    return (
      <div className="contestNavigation">
        <nav className="contestNavigation--inner">
          <h2 className="contestNavigation--header">{this.props.contest.name}</h2>
          <Link className="contestNavigation--homeLink" to={`/contests/${this.props.contest.id}${t('locale')}`}>
            {t('contest_home')}
          </Link>
          {this.props.contest.problems &&
            this.props.contest.problems.map((problem: ProblemObject) => (
              <div key={problem.id} className="contestNavigation--problem">
                <Link
                  className="contestNavigation--problemLink"
                  key={problem.id}
                  to={`/contests/${this.props.contest.id}/problems/${problem.id}${t('locale')}`}
                >
                  {problem.task} - {problem.name}
                </Link>
                {problem.dataSets.map((dataSet: DataSetObject) => (
                  <div key={dataSet.id} className="contestNavigation--dataSet">
                    <i
                      className={`contestNavigation--dataSetCheck__${
                        dataSet.correct ? 'correct' : 'incorrect'
                      } fa fa-check`}
                    />
                    {dataSet.label}: {dataSet.score}/{dataSet.maxScore}
                  </div>
                ))}
              </div>
            ))}
          {this.props.contest.problems && (
            <Link
              className="contestNavigation--submissionsLink"
              to={`/contests/${this.props.contest.id}/submissions${t('locale')}`}
            >
              {t('submissions')}
            </Link>
          )}
          {this.props.contest.problems && (
            <Link
              className="contestNavigation--rankingLink"
              to={`/contests/${this.props.contest.id}/ranking${t('locale')}`}
            >
              {t('ranking')}
            </Link>
          )}
          {this.props.contest.editorial &&
            this.props.contest.editorial.id && (
              <Link
                className="contestNavigation--rankingLink"
                to={`/contests/${this.props.contest.id}/editorials/${this.props.contest.editorial.id}${t('locale')}`}
              >
                {t('editorial')}
              </Link>
            )}
        </nav>
      </div>
    );
  }
}
