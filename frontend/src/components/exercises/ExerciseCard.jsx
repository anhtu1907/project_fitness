import React from "react";

function ExerciseCard({ exercise }) {
  return (
    <div className="bg-white border rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-all duration-300">
      {/* Ảnh bài tập */}
      <img
        src={exercise.exerciseImage}
        alt={exercise.exerciseName}
        className="w-full h-48 object-cover"
      />

      <div className="p-4">
        {/* Tên bài tập */}
        <h3 className="text-lg font-bold text-gray-800 mb-2 line-clamp-2">
          {exercise.exerciseName}
        </h3>

        {/* Thời lượng */}
        <p className="text-sm text-gray-500 mb-1">
          Duration: {exercise.duration || 0} min
        </p>

        {/* Calo */}
        <p className="text-sm text-gray-500">
          Calories: {exercise.kcal || 0} kcal
        </p>
      </div>
    </div>
  );
}

export default ExerciseCard;
