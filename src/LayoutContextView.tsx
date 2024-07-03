import * as React from 'react';
import ReactNativeLayoutContextView from './ReactNativeLayoutContextView';
import { LayoutContext } from './LayoutContext';
import { StyleProp, ViewStyle } from 'react-native';

//
// ID must be globally unique
//

let nextId = 0;
function allocateId() {
    return `context-${nextId++}`;
}

//
// Simple wrapper
//

export type LayoutContextViewProps = {
    children?: React.ReactNode;
    style?: StyleProp<ViewStyle>;
};

export const LayoutContextView = React.memo((props: LayoutContextViewProps) => {
    const name = React.useMemo(() => allocateId(), []);
    return (
        <LayoutContext.Provider value={name}>
            <ReactNativeLayoutContextView {...props} name={name} />
        </LayoutContext.Provider>
    )
});