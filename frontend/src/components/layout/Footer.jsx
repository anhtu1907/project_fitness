import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import ATMImage from "../../assets/images/payment-method.avif";
import BCTImage from "../../assets/images/bct.avif";

function Footer() {
  return (
    <footer className="flex flex-col justify-center bg-gradient-to-t from-sky-400 to-sky-200">
      <div className="p-4">
        <div className="flex justify-between items-start mb-2">
          <div className="text-center">
            <h3 className="text-2xl font-bold text-white">MAIN FUNCTIONS</h3>
            <ul className="list-none font-light text-amber-950">
              <li>Courses</li>
              <li>Tracking</li>
              <li>Videos</li>
              <li>Products</li>
            </ul>
          </div>
          <div className="text-center">
            <h3 className="text-2xl font-bold text-white">SUPPORT</h3>
            <ul className="list-none font-bold text-4xl text-red-900">
              <li>094 456 1024</li>
              <li>support@gmail.com</li>
            </ul>
          </div>
          <div className="text-center">
            <h3 className="text-2xl font-bold text-white">OUR APP</h3>
            <ul className="list-none font-light text-amber-950">
              <li>About Us</li>
              <li>Contact Us</li>
              <li>Guidance</li>
              <li>Releases</li>
            </ul>
          </div>
          <div className="text-center flex flex-col justify-evenly gap-6">
            <h3 className="text-2xl font-bold text-white">CONNECT</h3>
            <div className="flex justify-between">
              <FontAwesomeIcon icon={["fab", "whatsapp"]} size="3x" />
              <FontAwesomeIcon icon={["fab", "x-twitter"]} size="3x" />
              <FontAwesomeIcon icon={["fab", "facebook"]} size="3x" />
              <FontAwesomeIcon icon={["fab", "facebook-messenger"]} size="3x" />
            </div>
            <p className="font-semibold text-[18px] text-sky-800">
              The best app for gym beginners 🏆.
            </p>
          </div>
        </div>
      </div>

      <div className="flex justify-between items-start">
        <div className="flex justify-start items-center gap-20 mt-8 p-8">
          <FontAwesomeIcon
            icon={["fab", "apple-pay"]}
            size="5x"
            className="text-white"
          />
          <FontAwesomeIcon
            icon={["fab", "paypal"]}
            size="5x"
            className="text-white"
          />

        </div>
      </div>
      <div className="bg-sky-800 px-8">
        <p className="text-end text-white">
          <i>Gym Application </i> | <b>{new Date().getFullYear()}</b>
        </p>
      </div>
    </footer>
  );
}

export default Footer;
