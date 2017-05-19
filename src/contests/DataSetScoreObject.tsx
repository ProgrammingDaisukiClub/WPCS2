interface DataSetScoreObject {
  id: number;
  label: string;
  correct: boolean;
  solvedAt?: Date;
  score?: number;
  wrongAnswers: number;
}

export default DataSetScoreObject;
