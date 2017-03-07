import ProblemObject from 'contests/ProblemObject';

interface ContestObject {
  id: number;
  name: string;
  description: string;
  problems?: [ProblemObject];
  joined: boolean;
  startAt: Date;
  endAt: Date;
}

export default ContestObject;
