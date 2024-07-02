import * as React from 'react';

export const LayoutContext = React.createContext<{ name: string }>({ name: '<root>' });

export function useLayoutContext() {
    return React.useContext(LayoutContext);
}