import React, { useState, useEffect } from "react";
import MainLayout from "../layouts/MainLayout";
import { getPromotions } from "../services/promotionService";

function PromotionPage() {
  const [promotions, setPromotions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchPromotions = async () => {
      try {
        setLoading(true);
        const response = await getPromotions();
        if (response.success) {
          setPromotions(response.data || []);
        } else {
          setError("Failed to load promotions");
        }
      } catch (err) {
        console.error("Error fetching promotions:", err);
        setError("Error loading promotions");
      } finally {
        setLoading(false);
      }
    };

    fetchPromotions();
  }, []);

  const today = new Date();
  today.setHours(0, 0, 0, 0); // Reset time to start of day

  // Separate promotions by date status (handle Unix timestamps)
  const currentPromotions = promotions.filter(promotion => {
    const startDate = new Date(promotion.startDate * 1000); // Convert Unix timestamp
    const endDate = new Date(promotion.endDate * 1000);
    return today >= startDate && today <= endDate;
  });

  const upcomingPromotions = promotions.filter(promotion => {
    const startDate = new Date(promotion.startDate * 1000);
    return today < startDate;
  });

  const pastPromotions = promotions.filter(promotion => {
    const endDate = new Date(promotion.endDate * 1000);
    return today > endDate;
  });

  const PromotionCard = ({ promotion, status }) => {
    const getPromotionImage = (name, discount) => {
      const images = {
        "Sale for End Year": "https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=800&h=600&fit=crop",
        "Black Friday Sale": "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=600&fit=crop",
        "Summer Clearance": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop",
        "Spring Sale": "https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=800&h=600&fit=crop"
      };
      return images[name] || `https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=600&fit=crop&q=80`;
    };

    return (
      <div
        key={promotion.id}
        className={`relative group overflow-hidden rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 h-96 ${
          status === 'past' ? 'opacity-60' : ''
        }`}
      >
        {/* Full Screen Background Image */}
        <img
          src={getPromotionImage(promotion.name, promotion.discount)}
          alt={promotion.name}
          className="absolute inset-0 w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
        />

        {/* Overlay Gradient - Sky Theme */}
        <div className="absolute inset-0 bg-gradient-to-t from-sky-900/80 via-sky-700/40 to-transparent"></div>

        {/* Status Badge */}
        <div className={`absolute top-4 left-4 px-3 py-1 rounded-full text-sm font-semibold z-10 ${
          status === 'current' ? 'bg-green-500 text-white' :
          status === 'upcoming' ? 'bg-blue-500 text-white' :
          'bg-gray-500 text-white'
        }`}>
          {status === 'current' ? 'ACTIVE NOW' :
           status === 'upcoming' ? 'COMING SOON' :
           'EXPIRED'}
        </div>

        {/* Discount Badge - Sky Theme */}
        <div className="absolute top-4 right-4 bg-gradient-to-r from-sky-500 to-sky-600 text-white px-4 py-2 rounded-full font-bold text-lg shadow-lg z-10">
          {(promotion.discount * 100).toFixed(0)}% OFF {/* Convert decimal to percentage */}
        </div>

        {/* Usage Limit Badge */}
        {promotion.usageLimit && (
          <div className="absolute top-16 right-4 bg-orange-500 text-white px-3 py-1 rounded-full text-sm font-semibold z-10">
            Limited: {promotion.usageLimit} uses
          </div>
        )}

        {/* Content Overlay */}
        <div className="absolute bottom-0 left-0 right-0 p-6 text-white z-10">
          <h2 className="text-2xl font-bold mb-2 text-white drop-shadow-lg">
            {promotion.name}
          </h2>

          <p className="text-sky-100 mb-4 line-clamp-2 drop-shadow">
            Save {(promotion.discount * 100).toFixed(0)}% on all eligible items!
            {promotion.usageLimit && ` Limited to ${promotion.usageLimit} customers.`}
          </p>

          <div className="flex items-center justify-between">
            {/* Date Info Box - Sky Theme */}
            <div className="text-sm bg-sky-200/20 backdrop-blur-sm rounded-lg px-3 py-2 border border-sky-300/30">
              <span className="block text-xs text-sky-200">
                {status === 'current' ? 'Valid Until' :
                 status === 'upcoming' ? 'Starts' :
                 'Ended'}
              </span>
              <span className="font-semibold text-white">
                {status === 'current' ? new Date(promotion.endDate * 1000).toLocaleDateString() :
                 status === 'upcoming' ? new Date(promotion.startDate * 1000).toLocaleDateString() :
                 new Date(promotion.endDate * 1000).toLocaleDateString()}
              </span>
            </div>

            {/* CTA Button - Sky Theme */}
            <button
              className={`px-6 py-2 rounded-full font-semibold transition-all duration-200 transform hover:scale-105 shadow-lg ${
                status === 'current' ? 'bg-gradient-to-r from-sky-400 to-sky-600 hover:from-sky-500 hover:to-sky-700 text-white hover:shadow-sky-500/25' :
                status === 'upcoming' ? 'bg-gradient-to-r from-blue-400 to-blue-600 hover:from-blue-500 hover:to-blue-700 text-white' :
                'bg-gray-400 text-gray-200 cursor-not-allowed'
              }`}
              disabled={status === 'past'}
              onClick={() => {
                if (status === 'current') {
                  // Navigate to products page
                  window.location.href = '/products';
                }
              }}
            >
              {status === 'current' ? 'Shop Now' :
               status === 'upcoming' ? 'Notify Me' :
               'Expired'}
            </button>
          </div>
        </div>

        {/* Hover Effect Border - Sky Theme */}
        <div className="absolute inset-0 border-2 border-transparent group-hover:border-sky-400/50 rounded-2xl transition-all duration-300 z-10"></div>
      </div>
    );
  };

  // Loading state
  if (loading) {
    return (
      <MainLayout>
        <div className="container mx-auto px-4 py-8">
          <div className="flex justify-center items-center min-h-[400px]">
            <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-sky-600"></div>
          </div>
        </div>
      </MainLayout>
    );
  }

  // Error state
  if (error) {
    return (
      <MainLayout>
        <div className="container mx-auto px-4 py-8">
          <div className="text-center py-16">
            <div className="text-red-400 text-6xl mb-4">⚠️</div>
            <h3 className="text-xl font-semibold text-red-700 mb-2">
              Error Loading Promotions
            </h3>
            <p className="text-red-600">{error}</p>
            <button
              onClick={() => window.location.reload()}
              className="mt-4 px-6 py-2 bg-sky-600 text-white rounded-lg hover:bg-sky-700 transition-colors"
            >
              Try Again
            </button>
          </div>
        </div>
      </MainLayout>
    );
  }

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-4xl font-bold text-center text-sky-800 mb-12">
          Special Promotions
        </h1>

        {/* Current Promotions */}
        {currentPromotions.length > 0 && (
          <div className="mb-12">
            <h2 className="text-2xl font-bold text-green-600 mb-6 flex items-center">
              <span className="w-3 h-3 bg-green-500 rounded-full mr-3"></span>
              Active Promotions ({currentPromotions.length})
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {currentPromotions.map((promotion) => (
                <PromotionCard key={promotion.id} promotion={promotion} status="current" />
              ))}
            </div>
          </div>
        )}

        {/* Upcoming Promotions */}
        {upcomingPromotions.length > 0 && (
          <div className="mb-12">
            <h2 className="text-2xl font-bold text-blue-600 mb-6 flex items-center">
              <span className="w-3 h-3 bg-blue-500 rounded-full mr-3"></span>
              Upcoming Promotions ({upcomingPromotions.length})
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {upcomingPromotions.map((promotion) => (
                <PromotionCard key={promotion.id} promotion={promotion} status="upcoming" />
              ))}
            </div>
          </div>
        )}

        {/* Past Promotions */}
        {pastPromotions.length > 0 && (
          <div className="mb-12">
            <h2 className="text-2xl font-bold text-gray-600 mb-6 flex items-center">
              <span className="w-3 h-3 bg-gray-500 rounded-full mr-3"></span>
              Past Promotions ({pastPromotions.length})
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {pastPromotions.map((promotion) => (
                <PromotionCard key={promotion.id} promotion={promotion} status="past" />
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {promotions.length === 0 && (
          <div className="text-center py-16">
            <div className="text-sky-400 text-6xl mb-4">🎉</div>
            <h3 className="text-xl font-semibold text-sky-700 mb-2">
              No Promotions Available
            </h3>
            <p className="text-sky-600">Check back later for amazing deals!</p>
          </div>
        )}
      </div>
    </MainLayout>
  );
}

export default PromotionPage;