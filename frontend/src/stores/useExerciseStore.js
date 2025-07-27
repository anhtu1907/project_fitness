import { create } from "zustand";
import BestExercisesData from "../data/best_exercises.json"

const useExerciseStore = create((set) => ({
  exercises: [],
  bestExercises: BestExercisesData,
}));

export default useExerciseStore;
