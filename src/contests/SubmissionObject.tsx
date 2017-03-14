interface SubmissionObject {
  id: number;
  problemId: number;
  dataSetId: number;
  judgeStatus: number;
  score: number;
  createdAt: Date;
}

export default SubmissionObject;
