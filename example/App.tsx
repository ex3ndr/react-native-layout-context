import * as React from 'react';
import { Button, Text, TextInput, View } from 'react-native';
import { NavigationContainer, useNavigation } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { LayoutAvoidingView, LayoutContextView, useLayoutContext } from 'react-native-layout-context';

const ContentView = React.memo((props: { autofocus: boolean }) => {
  const navigation = useNavigation() as any;
  const layout = useLayoutContext();
  return (
    <LayoutAvoidingView style={{ flexGrow: 1, alignSelf: 'stretch', justifyContent: 'center', alignItems: 'center', gap: 16 }}>
      <View style={{ justifyContent: 'center', alignItems: 'center', gap: 16 }}>
        <Text style={{ fontSize: 24, color: 'white', fontWeight: '600', marginBottom: 16 }}>{layout}</Text>
        <TextInput style={{ width: 200, height: 48, backgroundColor: 'white', borderRadius: 8, fontSize: 18, paddingHorizontal: 16 }} placeholder='Tap me' autoFocus={props.autofocus} />
        <TextInput style={{ width: 200, height: 48, backgroundColor: 'white', borderRadius: 8, fontSize: 18, paddingHorizontal: 16 }} placeholder='Tap me' />
        <View>
          <Button
            title="Same"
            onPress={() => navigation.push('Double')}
          />
          <Button
            title="Autofocus"
            onPress={() => navigation.push('Autofocus')}
          />
          <Button
            title="AutofocusModal"
            onPress={() => navigation.push('AutofocusModal')}
          />
        </View>
      </View>
    </LayoutAvoidingView>
  )
});


function DoubleScreen() {
  return (
    <View style={{ flexDirection: 'row', flexGrow: 1, flexBasis: 0, alignItems: 'stretch' }}>
      <LayoutContextView style={{ flexGrow: 1, flexBasis: 0, backgroundColor: 'red', flexDirection: 'column' }}>
        <ContentView autofocus={false} />
      </LayoutContextView>
      <LayoutContextView style={{ flexGrow: 1, flexBasis: 0, backgroundColor: 'blue', flexDirection: 'column' }}>
        <ContentView autofocus={false} />
      </LayoutContextView>
    </View>
  );
}

function AutofocusScreen() {
  return (
    <View style={{ flexDirection: 'row', flexGrow: 1, flexBasis: 0, alignItems: 'stretch' }}>
      <LayoutContextView style={{ flexGrow: 1, flexBasis: 0, backgroundColor: 'red', flexDirection: 'column' }}>
        <ContentView autofocus={true} />
      </LayoutContextView>
    </View>
  );
}

function HomeScreen() {
  const navigation = useNavigation() as any;
  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Button
        title="Double pane"
        onPress={() => navigation.push('Double')}
      />
    </View>
  );
}

//
// Stack
//

const Stack = createNativeStackNavigator();

function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="Double" component={DoubleScreen} />
        <Stack.Screen name="Autofocus" component={AutofocusScreen} />
        <Stack.Screen name="AutofocusModal" component={AutofocusScreen} options={{ presentation: 'formSheet' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default App;