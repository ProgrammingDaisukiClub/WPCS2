import * as React from 'react';
import { Link } from 'react-router';

/**
 * A class of sample react application root component.
 */
export default class App extends React.Component<{}, {}> {
  public render() {
    return (
      <div>
        <div>
          <div>Navigation - { t('hello') }</div>
          <ul>
            <li><Link to='/react_tutorial'>Contest Home</Link></li>
            <li>
              <div>Problems</div>
              <ul>
                <li><Link to='/react_tutorial/problems/1'>Problem1</Link></li>
                <li><Link to='/react_tutorial/problems/2'>Problem2</Link></li>
                <li><Link to='/react_tutorial/problems/3'>Problem3</Link></li>
                <li><Link to='/react_tutorial/problems/4'>Problem4</Link></li>
              </ul>
            </li>
            <li><Link to='/react_tutorial/ranking'>Ranking</Link></li>
            <li><Link to='/react_tutorial/statement_test'>Statement Parse Test</Link></li>
          </ul>
        </div>
        <div>
          <div>Main Contents</div>
          { this.props.children }
        </div>
      </div>
    );
  }
}
