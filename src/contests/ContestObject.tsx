import ProblemObject from 'contests/ProblemObject';

interface ContestObject {
  id: number;
  name: string;
  description: string;
  problems?: [ProblemObject];
  joined: boolean;
  currentUserId: number;
  startAt: Date;
  endAt: Date;
  baseline: number;
}

export default ContestObject;
