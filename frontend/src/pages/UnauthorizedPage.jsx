import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const UnauthorizedPage = () => {
  const navigate = useNavigate();

  const handleGoBack = () => {
    navigate(-1); // Go back to previous page
  };

  const handleGoHome = () => {
    navigate('/');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-red-50 to-red-100 flex items-center justify-center px-4">
      <div className="max-w-lg w-full bg-white rounded-2xl shadow-2xl p-8 text-center">
        {/* Error Icon */}
        <div className="mb-6">
          <div className="mx-auto w-24 h-24 bg-red-100 rounded-full flex items-center justify-center">
            <FontAwesomeIcon
              icon={["fas", "lock"]}
              className="text-red-600 text-4xl"
            />
          </div>
        </div>

        {/* Error Code */}
        <div className="mb-4">
          <h1 className="text-6xl font-bold text-red-600 mb-2">401</h1>
          <h2 className="text-2xl font-bold text-gray-800 mb-2">Unauthorized Access</h2>
        </div>

        {/* Error Message */}
        <div className="mb-8">
          <p className="text-gray-600 text-lg mb-4">
            Oops! You don't have permission to access this page.
          </p>
          <p className="text-gray-500 text-sm">
            You need to be logged in or have the proper authorization to view this content.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="space-y-4">
          {/* Login Button */}
          <Link
            to="/login"
            className="w-full bg-gradient-to-r from-sky-500 to-sky-600 hover:from-sky-600 hover:to-sky-700 text-white font-bold py-3 px-6 rounded-lg transition duration-300 transform hover:scale-105 shadow-lg flex items-center justify-center gap-2"
          >
            <FontAwesomeIcon icon={["fas", "sign-in-alt"]} />
            Sign In
          </Link>

          {/* Register Button */}
          <Link
            to="/register"
            className="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-3 px-6 rounded-lg transition duration-300 transform hover:scale-105 shadow-lg flex items-center justify-center gap-2"
          >
            <FontAwesomeIcon icon={["fas", "user-plus"]} />
            Create Account
          </Link>

          {/* Navigation Buttons */}
          <div className="flex gap-4">
            <button
              onClick={handleGoBack}
              className="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition duration-200 flex items-center justify-center gap-2"
            >
              <FontAwesomeIcon icon={["fas", "arrow-left"]} />
              Go Back
            </button>

            <button
              onClick={handleGoHome}
              className="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition duration-200 flex items-center justify-center gap-2"
            >
              <FontAwesomeIcon icon={["fas", "home"]} />
              Home
            </button>
          </div>
        </div>

        {/* Help Section */}
        <div className="mt-8 pt-6 border-t border-gray-200">
          <p className="text-gray-500 text-sm mb-2">Need help?</p>
          <div className="flex justify-center gap-4 text-sm">
            <Link
              to="/contact"
              className="text-sky-600 hover:text-sky-800 transition duration-200"
            >
              Contact Support
            </Link>
            <span className="text-gray-400">|</span>
            <Link
              to="/help"
              className="text-sky-600 hover:text-sky-800 transition duration-200"
            >
              Help Center
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UnauthorizedPage;