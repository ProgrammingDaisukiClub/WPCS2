import 'babel-polyfill';

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { BrowserRouter, Route } from 'react-router-dom';
import 'whatwg-fetch';

import ContestApp from 'contests/ContestApp';

ReactDOM.render(
  <BrowserRouter>
    <Route path="/contests/:contestId" component={ContestApp} />
  </BrowserRouter>,
  document.getElementById('contests-app')
);
