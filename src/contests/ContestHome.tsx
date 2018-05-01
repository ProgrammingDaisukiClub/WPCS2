import ContestObject from 'contests/ContestObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';
import * as React from 'react';

export interface ContestHomeProps {
  contest: ContestObject;
  join(): void;
}

export interface ContestHomeState {
  password: string;
  contestStatus: string;
  passwordFormStyleState: any;
}

export default class ContestHome extends React.Component<ContestHomeProps, ContestHomeState> {
  constructor(props: ContestHomeProps) {
    super(props);
    this.state = {
      password: '',
      contestStatus: '',
      passwordFormStyleState: {},
    };
  }

  public render(): JSX.Element {
    this.fetchContestStatus();

    return (
      <div className="contestHome">
        <div className="contestHome--inner">
          <h2 className="contestHome--header">{this.props.contest.name}</h2>
          <div className="contestHome--body">
            {!this.props.contest.adminRole &&
              this.props.contest.currentUserId &&
              (!this.props.contest.joined && new Date() < this.props.contest.endAt) && (
                <div className="contestHome--registrationButtonWrapper">
                  <form style={this.state.passwordFormStyleState}>
                    <input
                      type="text"
                      value={this.state.password}
                      onChange={(e: React.ChangeEvent<HTMLInputElement>): void => {
                        this.setState({ password: e.target.value });
                      }}
                    />
                  </form>
                  <span
                    role="button"
                    className="contestHome--registrationButton"
                    onClick={(): void => {
                      this.submitPasswordValidationAPI();
                    }}
                  >
                    {t('join')}
                  </span>
                </div>
              )}
            {!this.props.contest.currentUserId && (
              <div className="contestHome--registrationButtonWrapper">
                <form style={this.state.passwordFormStyleState}>
                  <input
                    type="text"
                    value={this.state.password}
                    onChange={(e: React.ChangeEvent<HTMLInputElement>): void => {
                      this.setState({ password: e.target.value });
                    }}
                  />
                </form>
                <a className="contestHome--registrationButton" href="/users/sign_up">
                  {t('join')}
                </a>
              </div>
            )}
            <MarkdownRenderer text={this.props.contest.description} />
          </div>
        </div>
      </div>
    );
  }

  private async fetchContestStatus(): Promise<void> {
    const responseContestStatus: Response = await fetch(`/api/contests/${this.props.contest.id}/status`, {
      credentials: 'same-origin',
    });

    switch (responseContestStatus.status) {
      case 200:
        const json: any = await responseContestStatus.json();
        const status: string = json.status;
        const isStatusInside: boolean = status === 'inside';

        this.setState({ contestStatus: status });

        if (!isStatusInside) {
          this.setState({
            passwordFormStyleState: { display: 'none' },
          });
        }

        break;

      case 404:
        throw new Error('404 not found');
      default:
        throw new Error('unexpected http status');
    }
  }

  private async submitPasswordValidationAPI(): Promise<void> {
    if (this.state.contestStatus === 'inside') {
      const responsePasswordValidation: Response = await fetch(`/api/contests/${this.props.contest.id}/validation`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          password: this.state.password,
        }),
        credentials: 'same-origin',
      });

      switch (responsePasswordValidation.status) {
        case 200:
          const json: any = await responsePasswordValidation.json();
          const submitStatus: boolean = json.result === 'ok';

          if (submitStatus) {
            this.props.join();
          } else {
            alert('password is invalid!');
          }
          break;

        case 404:
          throw new Error('404 not found');
        default:
          throw new Error('unexpected http status');
      }
    } else {
      this.props.join();
    }
  }
}
