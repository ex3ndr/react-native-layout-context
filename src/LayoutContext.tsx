import * as React from 'react';

export const LayoutContext = React.createContext<string | null>(null);

export function useLayoutContext() {
    return React.useContext(LayoutContext);
}