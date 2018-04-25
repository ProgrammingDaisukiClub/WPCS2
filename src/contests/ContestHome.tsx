import * as React from 'react';
import ContestObject from 'contests/ContestObject';
import MarkdownRenderer from 'contests/MarkdownRenderer';

export interface ContestHomeProps {
  contest: ContestObject;
  join: () => void;
}

export interface ContestHomeState {
  password: string;
}

export default class ContestHome extends React.Component<ContestHomeProps, ContestHomeState> {
  constructor(props: ContestHomeProps){
    super(props)
    this.state = {
      password: ""
    }
  }

  private async fetchContestStatus(){
      const responseContestStatus: Response = await fetch(`/api/contests/${this.props.contest.id}/status`, {
        credentials: 'same-origin',
      });

      switch(responseContestStatus.status) {
        case 200:
          const json: any = await responseContestStatus.json();
          status = json.status
          break;

        case 404: throw new Error('404 not found');
        default: throw new Error('unexpected http status');
      }

      let isStatusInside: boolean = status == "inside";
      return isStatusInside;
  }

  private async submitPasswordValidationAPI(){
    const responsePasswordValidation: Response = await fetch(`/api/contests/${this.props.contest.id}/validation`, {
      method: 'POST',
      body: JSON.stringify(
        {
          'password': this.state.password
        }
      ),
      credentials: 'same-origin',
    });

    switch(responsePasswordValidation.status){
      case 200:
        const json: any = await responsePasswordValidation.json();
        const submitStatus: boolean = json.status == "ok"

        if(submitStatus){
          this.props.join();
        }else{
          alert("password is invalid!");
        }

      case 404: throw new Error('404 not found');
      default: throw new Error('unexpected http status');
    }
  }

  public render() {
    let hiddenPasswordForm: any = this.fetchContestStatus() ? {} : { display: "none" };

    return (
      <div className="contestHome">
        <div className="contestHome--inner">
          <h2 className="contestHome--header">{ this.props.contest.name }</h2>
          <div className="contestHome--body">
            { !this.props.contest.adminRole && this.props.contest.currentUserId && (!this.props.contest.joined && new Date() < this.props.contest.endAt) &&
              <div className="contestHome--registrationButtonWrapper">
                <form style={ hiddenPasswordForm }>
                  <input type='text'　value={ this.state.password } onChange={ (e) => this.setState({ password: e.target.value}) }　/>
                </form>
                <span className="contestHome--registrationButton" onClick={ () => this.submitPasswordValidationAPI() }>
                  { t('join') }
                </span>
              </div>
            }
            { !this.props.contest.currentUserId &&
              <div className="contestHome--registrationButtonWrapper">
                <form style={ hiddenPasswordForm }>
                  <input type='text'　value={ this.state.password } onChange={ (e) => this.setState({ password: e.target.value} ) }　/>
                </form>
                <a className="contestHome--registrationButton" href="/users/sign_up">{ t('join') }</a>
              </div>
            }
            <MarkdownRenderer text={ this.props.contest.description } />
          </div>
        </div>
      </div>
    );
  }
}
