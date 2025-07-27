import { Link } from "react-router-dom";

function ExerciseLinkCard({ id, name, image, type, duration, level }) {
  // Get level styling
  const getLevelStyle = (level) => {
    switch (level.toLowerCase()) {
      case 'easy':
        return 'bg-green-100 text-green-800 border-green-200';
      case 'medium':
        return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'hard':
        return 'bg-red-100 text-red-800 border-red-200';
      default:
        return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  // Get type styling
  const getTypeStyle = (type) => {
    switch (type.toLowerCase()) {
      case 'beginner':
        return 'bg-blue-100 text-blue-800';
      case 'intermediate':
        return 'bg-purple-100 text-purple-800';
      case 'advanced':
        return 'bg-orange-100 text-orange-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <div className="relative group flex flex-col bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 overflow-hidden h-96">
      {/* Image Container */}
      <div className="relative h-56 overflow-hidden">
        <img
          className="object-cover h-full w-full transition-transform duration-500 group-hover:scale-110"
          src={image}
          alt={name}
        />

        {/* Level Badge */}
        <div className={`absolute top-3 left-3 px-3 py-1 rounded-full text-xs font-semibold shadow-lg border ${getLevelStyle(level)} z-10`}>
          {level.toUpperCase()}
        </div>

        {/* Duration Badge */}
        <div className="absolute top-3 right-3 bg-black/70 text-white px-3 py-1 rounded-full text-xs font-semibold shadow-lg z-10">
          {duration}min
        </div>

        {/* Overlay Gradient */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>

        {/* Play Icon Overlay */}
        <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
          <div className="bg-white/90 rounded-full p-4 transform scale-75 group-hover:scale-100 transition-transform duration-300">
            <svg className="w-8 h-8 text-sky-600" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clipRule="evenodd" />
            </svg>
          </div>
        </div>
      </div>

      {/* Content Container */}
      <div className="flex flex-col flex-1 p-4">
        {/* Workout Name */}
        <h3 className="text-lg font-bold text-gray-800 mb-2 line-clamp-2 group-hover:text-sky-600 transition-colors duration-200">
          {name}
        </h3>

        {/* Workout ID */}
        <p className="text-xs text-gray-500 mb-3">
          Exercise #{id}
        </p>

        {/* Workout Info */}
        <div className="flex items-center justify-between mb-4">
          {/* Type Badge */}
          <div className={`px-3 py-1 rounded-full text-xs font-medium ${getTypeStyle(type)}`}>
            {type.charAt(0).toUpperCase() + type.slice(1)}
          </div>

          {/* Duration Info */}
          <div className="flex items-center text-gray-600 text-sm">
            <svg className="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clipRule="evenodd" />
            </svg>
            {duration} minutes
          </div>
        </div>

        {/* Action Button */}
        <Link
          to={`/exercises/${id}`}
          className="w-full py-3 text-center font-semibold rounded-xl transition-all duration-200 transform hover:scale-105 shadow-md bg-gradient-to-r from-sky-500 to-sky-600 hover:from-sky-600 hover:to-sky-700 text-white hover:shadow-lg mt-auto"
        >
          Start Workout
        </Link>
      </div>

      {/* Hover Border Effect */}
      <div className="absolute inset-0 border-2 border-transparent group-hover:border-sky-400/50 rounded-2xl transition-all duration-300 pointer-events-none"></div>
    </div>
  );
}

export default ExerciseLinkCard;