import { library } from "@fortawesome/fontawesome-svg-core";
import {
  faHome,
  faUser,
  faShoppingCart,
  faAnglesLeft,
  faAnglesRight,
  faDownLong,
  faXmark,
  faToolbox,
  faPills,
  faStar,
  faPlus,
  faMinus,
  faTrash,
  faTimesCircle,
  faCheckCircle,
  faLock,
  faSignInAlt,
  faUserPlus,
  faArrowLeft,
  faChevronDown,
  faChevronRight,
  faExclamationTriangle,
  faTag,
  faShoppingBag,
  faDollarSign,
  faClock,
  faReceipt,
  faTruck,
  faTimes
} from "@fortawesome/free-solid-svg-icons"; // Solid icons : fas
import {
  faBell,
 } from "@fortawesome/free-regular-svg-icons"; // Regular icons : far
import {
  faFacebook,
  faFacebookMessenger,
  faXTwitter,
  faWhatsapp,
  faApplePay,
  faPaypal,
  faFacebookF,
  faGooglePlusG,
  faGooglePlay,
} from "@fortawesome/free-brands-svg-icons"; // Brand icons : fab

// Add icons to library
library.add(faAnglesLeft, faAnglesRight);
library.add(faHome, faUser, faDownLong, faShoppingCart, faXmark,
  faStar, faPlus, faMinus, faTrash, faTimesCircle, faCheckCircle,
  faLock, faSignInAlt, faUserPlus, faArrowLeft, faChevronDown, faChevronRight,
  faExclamationTriangle, faTag, faShoppingBag, faDollarSign, faClock,
  faReceipt, faTruck, faTimes
);
library.add(faFacebook, faFacebookMessenger, faXTwitter, faWhatsapp);
library.add(faApplePay, faPaypal);
library.add(faFacebookF, faGooglePlusG, faGooglePlay);
library.add(faBell);
library.add(faToolbox, faPills);

/*
 https://docs.fontawesome.com/v5/web/use-with/react

 Basic use:

 import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
 <FontAwesomeIcon icon={["fas", "shopping-cart"]} size="2x" />

- Attributes:
  - icon
  - size
  - spin
*/