import React from "react";

function MealCard({ meal }) {
  return (
    <div className="bg-white border rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-all duration-300">
      {/* Ảnh món ăn */}
      <img
        src={meal.mealImage}
        alt={meal.mealName}
        className="w-full h-48 object-cover"
      />

      {/* Nội dung */}
      <div className="p-4">
        {/* Tên món */}
        <h3 className="text-lg font-bold text-gray-800 mb-2 line-clamp-2">
          {meal.mealName}
        </h3>

        {/* Calories & weight */}
        <div className="text-sm text-gray-600 mb-1">
          <span className="mr-2">🔥 {meal.kcal} kcal</span>
          <span>⚖️ {meal.weight} g</span>
        </div>

        {/* Time of day */}
        {meal.timeOfDay && meal.timeOfDay.length > 0 && (
          <p className="text-xs text-gray-500 italic">
            🕒 Best for:{" "}
            {meal.timeOfDay.map((t) => t.timeName).join(", ")}
          </p>
        )}

        {/* Thành phần dinh dưỡng */}
        <div className="mt-2 text-xs text-gray-500 grid grid-cols-2 gap-y-1">
          <span>🥩 Protein: {meal.protein}g</span>
          <span>🧈 Fat: {meal.fat}g</span>
          <span>🍬 Sugar: {meal.sugar}g</span>
          <span>🌾 Carbs: {meal.carbohydrate}g</span>
        </div>
      </div>
    </div>
  );
}

export default MealCard;
