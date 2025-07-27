import React from "react";

import AllRoutes from "./routes/Routes";

import { configureRealBackend } from "./helpers";
import { Toaster } from "react-hot-toast";
import "nouislider/distribute/nouislider.css";

import "./assets/scss/app.scss";
import "./assets/scss/icons.scss";

// configure real backend
configureRealBackend();

const App = () => {
  return (
    <>
      <Toaster
        position="top-center"
        reverseOrder={false}
        toastOptions={{
          duration: 5000,
          style: {
            fontSize: "16px",
            padding: "16px",
            maxWidth: "400px",
          },
        }}
      />
      <React.Fragment>
        <AllRoutes />
      </React.Fragment>
    </>
  );
};

export default App;
