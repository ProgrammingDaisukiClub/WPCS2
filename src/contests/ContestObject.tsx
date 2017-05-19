import ProblemObject from 'contests/ProblemObject';
import EditorialObject from 'contests/EditorialObject';

interface ContestObject {
  id: number;
  name: string;
  description: string;
  problems?: [ProblemObject];
  joined: boolean;
  currentUserId: number;
  adminRole: boolean;
  startAt: Date;
  endAt: Date;
  baseline: number;
  editorial?: EditorialObject;
}

export default ContestObject;
