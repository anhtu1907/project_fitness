import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

const Modal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  return (
    // The Modal
    <div
      className="fixed inset-0 z-50 flex items-center justify-center min-h-screen bg-black/40"
      onClick={handleBackdropClick}
    >
      {/* Modal Content */}
      <div className="relative rounded shadow-lg bg-white">
        <button
          type="button"
          className="absolute top-0 right-0 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center"
          onClick={onClose}
        >
          <FontAwesomeIcon icon={["fas", "xmark"]} size="2x" />
        </button>
        {/* Children */}
        {children}
      </div>
    </div>
  );
};

export default Modal;
