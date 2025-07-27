import { Link } from "react-router-dom";

// images
import logoLight from '../assets/images/logo-light.png';
import logoDark from '../assets/images/logo-dark.png';

function AuthLayout(props) {
  const {
    children,
    authTitle,
    helpText,
    bottomLinks,
    userImage,
  } = props;

  return (
    <div className="relative bg-gradient-to-r from-rose-100 to-teal-100 min-h-screen flex items-center justify-center">
      {/* Logo blur background */}
      <div className="absolute inset-0 flex items-center justify-center z-0">
        <img
          src={logoDark}
          alt="logo-blur"
          className="h-96 w-auto blur-md opacity-20"
          style={{ filter: "blur(8px)" }}
        />
      </div>

      {/* Form Container */}
      <div className="relative z-10 w-full max-w-md bg-white shadow-2xl rounded-2xl p-6">
        {/* Logo header */}
        {userImage ? (
          <div className="flex justify-between items-center mb-6">
            <div className="flex flex-col gap-2">
              <Link to="/">
                <img className="h-10 block dark:hidden" src={logoDark} alt="logo" />
                <img className="h-10 hidden dark:block" src={logoLight} alt="logo" />
              </Link>
              <h4 className="text-slate-900 dark:text-slate-200/50 font-semibold">Hi! Adam</h4>
            </div>
            <img src={userImage} alt="user-avatar" className="h-12 w-12 rounded-full shadow" />
          </div>
        ) : (
          <Link to="/" className="block mb-6">
            <img className="h-10 block dark:hidden mx-auto" src={logoDark} alt="logo" />
            <img className="h-10 hidden dark:block mx-auto" src={logoLight} alt="logo" />
          </Link>
        )}

        {/* Title */}
        {authTitle && (
          <h2 className="block w-full text-xl font-bold text-center text-gray-800 mb-6">{authTitle}</h2>
        )}
        {helpText && (
          <p className="text-center text-sm text-gray-500 mb-6">{helpText}</p>
        )}

        {/* Form content */}
        {children}

        {bottomLinks && (
          <div className="mt-6 text-center">
            {bottomLinks}
          </div>
        )}
        {/* OR Divider */}
        <div className="flex items-center my-6">
          <div className="flex-grow border-t border-dashed border-gray-300"></div>
          <span className="mx-4 text-sm text-gray-400">Or</span>
          <div className="flex-grow border-t border-dashed border-gray-300"></div>
        </div>


      </div>
    </div>
  );
}

export default AuthLayout;
