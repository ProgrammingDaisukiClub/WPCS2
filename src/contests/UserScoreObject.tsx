import ProblemScoreObject from 'contests/ProblemScoreObject';

interface UserScoreObject {
  id: number;
  totalScore: number;
  name: string;
  problems: [ ProblemScoreObject ];
}

export default UserScoreObject;
