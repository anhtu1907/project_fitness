import Header from "../components/layout/Header";
import Footer from "../components/layout/Footer";
import Announcement from "../components/layout/Announcement";

function MainLayout({ children }) {
  const settings = {
    autoPlay: true,
    interval: 3000,
  };
  return (
    <div className="overflow-x-hidden h-screen">
      <Announcement autoPlay={settings.autoPlay} interval={settings.interval} />
      <Header />
      <main className="container relative mx-auto">{children}</main>
      <Footer />
    </div>
  );
}

export default MainLayout;
