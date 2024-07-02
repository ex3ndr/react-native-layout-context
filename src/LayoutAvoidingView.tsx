import * as React from 'react';
import { LayoutAnimation, StyleProp, View, ViewStyle } from 'react-native';
import { useLayoutContext } from './LayoutContext';
import { addLayoutEventListener } from './LayoutEvents';

export type LayoutAvoidingViewProps = {
    children?: React.ReactNode;
    style?: StyleProp<ViewStyle>;
}

export const LayoutAvoidingView = React.memo((props: LayoutAvoidingViewProps) => {

    // Load the layout context
    const layout = useLayoutContext();
    const [keyboardHeight, setKeyboardHeight] = React.useState(0);

    // Subscribe to keyboard events
    React.useLayoutEffect(() => {
        let lastHeight = 0;
        let subscription = addLayoutEventListener((event) => {
            console.log(event);
            let targetHeight = 0;
            if (event.context === layout) {
                targetHeight = event.screen.height - event.endCoordinates.screenY;
            }
            if (targetHeight !== lastHeight) {
                lastHeight = targetHeight;

                // Animate the layout change
                LayoutAnimation.configureNext({
                    duration: event.duration > 10 ? event.duration : 10,
                    update: {
                        duration: event.duration > 10 ? event.duration : 10,
                        type: LayoutAnimation.Types[event.easing] || 'keyboard',
                    },
                });
                setKeyboardHeight(targetHeight);
            }
        });
        return () => {
            subscription.remove();
        }
    }, []);

    return (
        <View style={[props.style, { paddingBottom: keyboardHeight }]}>
            {props.children}
        </View>
    )
});