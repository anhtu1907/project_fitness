import React, { useState, useEffect } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

function Notification({ message, type = 'info', isVisible, onClose, duration = 5000 }) {
  const [isAnimating, setIsAnimating] = useState(false);

  useEffect(() => {
    if (isVisible) {
      setIsAnimating(true);

      // Auto-close after duration
      const timer = setTimeout(() => {
        handleClose();
      }, duration);

      return () => clearTimeout(timer);
    }
  }, [isVisible, duration]);

  const handleClose = () => {
    setIsAnimating(false);
    setTimeout(() => {
      onClose();
    }, 300); // Wait for animation to complete
  };

  if (!isVisible) return null;

  const getTypeStyles = () => {
    switch (type) {
      case 'success':
        return {
          bg: 'bg-gradient-to-r from-emerald-500 to-green-500',
          border: 'border-emerald-300',
          text: 'text-white',
          icon: 'check-circle',
          iconColor: 'text-emerald-100',
          iconBg: 'bg-white/20',
          progressBar: 'bg-emerald-200/30',
          shadow: 'shadow-emerald-500/25'
        };
      case 'error':
        return {
          bg: 'bg-gradient-to-r from-rose-500 to-red-500',
          border: 'border-rose-300',
          text: 'text-white',
          icon: 'times-circle',
          iconColor: 'text-rose-100',
          iconBg: 'bg-white/20',
          progressBar: 'bg-rose-200/30',
          shadow: 'shadow-rose-500/25'
        };
      case 'warning':
        return {
          bg: 'bg-gradient-to-r from-amber-500 to-orange-500',
          border: 'border-amber-300',
          text: 'text-white',
          icon: 'exclamation-triangle',
          iconColor: 'text-amber-100',
          iconBg: 'bg-white/20',
          progressBar: 'bg-amber-200/30',
          shadow: 'shadow-amber-500/25'
        };
      case 'info':
      default:
        return {
          bg: 'bg-gradient-to-r from-blue-500 to-cyan-500',
          border: 'border-blue-300',
          text: 'text-white',
          icon: 'info-circle',
          iconColor: 'text-blue-100',
          iconBg: 'bg-white/20',
          progressBar: 'bg-blue-200/30',
          shadow: 'shadow-blue-500/25'
        };
    }
  };

  const styles = getTypeStyles();

  return (
    <div
      className={`fixed top-4 right-4 z-50 transform transition-all duration-500 ease-out ${
        isAnimating
          ? 'translate-x-0 opacity-100 scale-100'
          : 'translate-x-full opacity-0 scale-95'
      }`}
    >
      <div className={`${styles.bg} ${styles.border} ${styles.text} ${styles.shadow} border backdrop-blur-sm rounded-2xl shadow-2xl min-w-80 max-w-md overflow-hidden`}>
        <div className="flex items-center p-5">
          {/* Icon with background */}
          <div className={`flex-shrink-0 ${styles.iconColor} ${styles.iconBg} p-2.5 rounded-xl`}>
            <FontAwesomeIcon icon={['fas', styles.icon]} size="lg" />
          </div>

          {/* Message */}
          <div className="ml-4 flex-1">
            <div className="text-sm font-semibold leading-relaxed drop-shadow-sm">{message}</div>
          </div>

          {/* Close Button */}
          <button
            onClick={handleClose}
            className={`flex-shrink-0 ml-4 ${styles.iconColor} hover:bg-white/20 p-2 rounded-lg transition-all duration-200 hover:scale-110`}
          >
            <FontAwesomeIcon icon={['fas', 'times']} size="sm" />
          </button>
        </div>

        {/* Enhanced Progress Bar */}
        <div className="h-1.5 bg-black/10 overflow-hidden">
          <div
            className={`h-full ${styles.progressBar} bg-white/40 transition-all linear relative`}
            style={{
              width: '100%',
              animation: `shrink ${duration}ms linear forwards`
            }}
          >
            {/* Shimmer effect */}
            <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 animate-pulse"></div>
          </div>
        </div>
      </div>

      <style jsx="true">{`
        @keyframes shrink {
          from {
            width: 100%;
          }
          to {
            width: 0%;
          }
        }
      `}</style>
    </div>
  );
}

// Enhanced Notification Hook with stacking support
export function useNotification() {
  const [notifications, setNotifications] = useState([]);

  const showNotification = (message, type = 'info', duration = 5000) => {
    const id = Date.now();
    const newNotification = {
      id,
      message,
      type,
      duration,
      isVisible: true
    };

    setNotifications(prev => [...prev, newNotification]);
  };

  const hideNotification = (id) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
  };

  const NotificationContainer = () => (
    <div className="fixed top-0 right-0 z-50 p-4 space-y-3 max-w-sm">
      {notifications.map((notification, index) => (
        <div
          key={notification.id}
          style={{
            transform: `translateY(${index * 10}px) scale(${1 - index * 0.05})`,
            zIndex: 1000 - index
          }}
          className="transition-all duration-300"
        >
          <Notification
            message={notification.message}
            type={notification.type}
            isVisible={notification.isVisible}
            duration={notification.duration}
            onClose={() => hideNotification(notification.id)}
          />
        </div>
      ))}
    </div>
  );

  return {
    showNotification,
    hideNotification,
    NotificationContainer
  };
}

export default Notification;