import { PageBreadcrumb } from "../../components"

const SimpleExample = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Example</h4>
        </div>
      </div>
      <div className="p-6">
        <ul className="max-w-xs flex flex-col">
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Profile
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Settings
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Newsletter
          </li>
        </ul>
      </div>
    </div>
  )
}

const ListGroupWithIcons = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Icons</h4>
        </div>
      </div>
      <div className="p-6">
        <ul className="max-w-xs flex flex-col">
          <li className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4.002 4.002 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4.002 4.002 0 0 0-3.203-3.92L8 1.917zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5.002 5.002 0 0 1 13 6c0 .88.32 4.2 1.22 6z" />
            </svg>
            Newsletter
          </li>
          <li className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path fillRule="evenodd" d="M7.646 10.854a.5.5 0 0 0 .708 0l2-2a.5.5 0 0 0-.708-.708L8.5 9.293V5.5a.5.5 0 0 0-1 0v3.793L6.354 8.146a.5.5 0 1 0-.708.708l2 2z" />
              <path d="M4.406 3.342A5.53 5.53 0 0 1 8 2c2.69 0 4.923 2 5.166 4.579C14.758 6.804 16 8.137 16 9.773 16 11.569 14.502 13 12.687 13H3.781C1.708 13 0 11.366 0 9.318c0-1.763 1.266-3.223 2.942-3.593.143-.863.698-1.723 1.464-2.383zm.653.757c-.757.653-1.153 1.44-1.153 2.056v.448l-.445.049C2.064 6.805 1 7.952 1 9.318 1 10.785 2.23 12 3.781 12h8.906C13.98 12 15 10.988 15 9.773c0-1.216-1.02-2.228-2.313-2.228h-.5v-.5C12.188 4.825 10.328 3 8 3a4.53 4.53 0 0 0-2.941 1.1z" />
            </svg>
            Downloads
          </li>
          <li className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z" />
            </svg>
            Team Account
          </li>
        </ul>
      </div>
    </div>
  )
}

const ListGroupWithLinks = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Links</h4>
        </div>
      </div>
      <div className="p-6">
        <div className="max-w-xs flex flex-col">
          <a className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium border text-primary -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg focus:z-10 focus:outline-none focus:ring-2 focus:ring-primary dark:border-gray-700" href="">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4.002 4.002 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4.002 4.002 0 0 0-3.203-3.92L8 1.917zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5.002 5.002 0 0 1 13 6c0 .88.32 4.2 1.22 6z" />
            </svg>
            Active
          </a>
          <a className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg hover:text-primary focus:z-10 focus:outline-none focus:ring-2 focus:ring-primary dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:hover:text-primary" href="">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path fillRule="evenodd" d="M7.646 10.854a.5.5 0 0 0 .708 0l2-2a.5.5 0 0 0-.708-.708L8.5 9.293V5.5a.5.5 0 0 0-1 0v3.793L6.354 8.146a.5.5 0 1 0-.708.708l2 2z" />
              <path d="M4.406 3.342A5.53 5.53 0 0 1 8 2c2.69 0 4.923 2 5.166 4.579C14.758 6.804 16 8.137 16 9.773 16 11.569 14.502 13 12.687 13H3.781C1.708 13 0 11.366 0 9.318c0-1.763 1.266-3.223 2.942-3.593.143-.863.698-1.723 1.464-2.383zm.653.757c-.757.653-1.153 1.44-1.153 2.056v.448l-.445.049C2.064 6.805 1 7.952 1 9.318 1 10.785 2.23 12 3.781 12h8.906C13.98 12 15 10.988 15 9.773c0-1.216-1.02-2.228-2.313-2.228h-.5v-.5C12.188 4.825 10.328 3 8 3a4.53 4.53 0 0 0-2.941 1.1z" />
            </svg>
            Link
          </a>
          <a className="inline-flex items-center gap-x-3.5 py-2.5 px-4 text-sm font-medium border text-gray-400 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg cursor-not-allowed focus:z-10 focus:outline-none focus:ring-2 focus:ring-primary dark:border-gray-700 dark:text-gray-700" href="">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z" />
            </svg>
            Disabled
          </a>
        </div>
      </div>
    </div>
  )
}

const StripedListGroup = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Striped</h4>            </div>
      </div>
      <div className="p-6">
        <ul className="max-w-xs flex flex-col">
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium odd:bg-gray-100 bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:odd:bg-slate-800 dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Profile
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium odd:bg-gray-100 bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:odd:bg-slate-800 dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Settings
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium odd:bg-gray-100 bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:odd:bg-slate-800 dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Newsletter
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium odd:bg-gray-100 bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:odd:bg-slate-800 dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Downloads
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium odd:bg-gray-100 bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:odd:bg-slate-800 dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            Team Account
          </li>
        </ul>
      </div>
    </div>
  )
}

const FlushListGroup = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Flush</h4>
        </div>
      </div>
      <div className="p-6">
        <ul className="max-w-xs flex flex-col divide-y divide-gray-200 dark:divide-gray-700">
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium text-gray-800 dark:text-white">
            Profile
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium text-gray-800 dark:text-white">
            Settings
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium text-gray-800 dark:text-white">
            Newsletter
          </li>
        </ul>
      </div>
    </div>
  )
}

const HorizontalListGroup = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Horizontal</h4>
        </div>
      </div>
      <div className="p-6">
        <ul className="flex flex-col sm:flex-row">
          <li className="inline-flex items-center gap-x-2.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg sm:-ms-px sm:mt-0 sm:first:rounded-tr-none sm:first:rounded-bl-lg sm:last:rounded-bl-none sm:last:rounded-tr-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4.002 4.002 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4.002 4.002 0 0 0-3.203-3.92L8 1.917zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5.002 5.002 0 0 1 13 6c0 .88.32 4.2 1.22 6z" />
            </svg>
            Newsletter
          </li>
          <li className="inline-flex items-center gap-x-2.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg sm:-ms-px sm:mt-0 sm:first:rounded-tr-none sm:first:rounded-bl-lg sm:last:rounded-bl-none sm:last:rounded-tr-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path fillRule="evenodd" d="M7.646 10.854a.5.5 0 0 0 .708 0l2-2a.5.5 0 0 0-.708-.708L8.5 9.293V5.5a.5.5 0 0 0-1 0v3.793L6.354 8.146a.5.5 0 1 0-.708.708l2 2z" />
              <path d="M4.406 3.342A5.53 5.53 0 0 1 8 2c2.69 0 4.923 2 5.166 4.579C14.758 6.804 16 8.137 16 9.773 16 11.569 14.502 13 12.687 13H3.781C1.708 13 0 11.366 0 9.318c0-1.763 1.266-3.223 2.942-3.593.143-.863.698-1.723 1.464-2.383zm.653.757c-.757.653-1.153 1.44-1.153 2.056v.448l-.445.049C2.064 6.805 1 7.952 1 9.318 1 10.785 2.23 12 3.781 12h8.906C13.98 12 15 10.988 15 9.773c0-1.216-1.02-2.228-2.313-2.228h-.5v-.5C12.188 4.825 10.328 3 8 3a4.53 4.53 0 0 0-2.941 1.1z" />
            </svg>
            Downloads
          </li>
          <li className="inline-flex items-center gap-x-2.5 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg sm:-ms-px sm:mt-0 sm:first:rounded-tr-none sm:first:rounded-bl-lg sm:last:rounded-bl-none sm:last:rounded-tr-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <svg className="flex-none" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z" />
            </svg>
            Team Account
          </li>
        </ul>
      </div>
    </div>
  )
}

const ListGroupWithBadges = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="flex justify-between items-center">
          <h4 className="card-title">Badges</h4>
        </div>
      </div>
      <div className="p-6">
        <ul className="max-w-xs flex flex-col">
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <div className="flex justify-between w-full">
              Profile
              <span className="inline-flex items-center py-1 px-2 rounded-full text-xs font-medium bg-primary text-white">New</span>
            </div>
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <div className="flex justify-between w-full">
              Settings
              <span className="inline-flex items-center py-1 px-2 rounded-full text-xs font-medium bg-primary text-white">2</span>
            </div>
          </li>
          <li className="inline-flex items-center gap-x-2 py-2.5 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
            <div className="flex justify-between w-full">
              Newsletter
              <span className="inline-flex items-center py-1 px-2 rounded-full text-xs font-medium bg-primary text-white">99+</span>
            </div>
          </li>
        </ul>
      </div>
    </div>
  )
}

const ListGroup = () => {
  return (
    <>
      <PageBreadcrumb title="List Group" name="List Group" breadCrumbItems={["Fitmate", "Components", "List Group"]} />
      <div className="grid lg:grid-cols-2 grid-cols-1 gap-6">
        <SimpleExample />
        <ListGroupWithIcons />
        <ListGroupWithLinks />
        <StripedListGroup />
        <FlushListGroup />
        <HorizontalListGroup />
        <ListGroupWithBadges />
      </div>
    </>
  )
}

export default ListGroup